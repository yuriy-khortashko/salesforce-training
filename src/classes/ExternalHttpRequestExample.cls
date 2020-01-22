public with sharing class ExternalHttpRequestExample {

    public static void iteratingThroughResponse() {
        HttpResponse response = sendTestRequest();
        JSONParser parser = JSON.createParser((String)JSON.deserializeUntyped(response.getBody()));
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'name')) {
                parser.nextToken();
                System.debug('name=' + parser.readValueAs(String.class));
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'price')) {
                parser.nextToken();
                System.debug('price=' + parser.getDoubleValue());
            }
        }
    }

    public static void parseResponseIntoCustomObjects() {
        HttpResponse response = sendTestRequest();
        List<Order> orders = (List<Order>) JSON.deserialize((String)JSON.deserializeUntyped(response.getBody()), List<Order>.class);
        for (Order order : orders) {
            System.debug('order: ' + order);
        }
    }

    private static HttpResponse sendTestRequest() {
        Http transport = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://lviv-courses-1-developer-edition.eu32.force.com/services/apexrest/products');
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('GET');
        return transport.send(request);
    }

    private class Order {
        public String price { get; set; }
        public String name { get; set; }
    }

}
