import ./make-test.nix {
  name = "tomcat";

  nodes = {
    server =
      { pkgs, config, ... }:

      { services.tomcat.enable = true;
        services.httpd.enable = true;
        services.httpd.adminAddr = "foo@bar.com";
        services.httpd.extraSubservices =
          [ { serviceType = "tomcat-connector"; } ];
        networking.firewall.allowedTCPPorts = [ 80 ];
      };

    client = { };
  };

  testScript = ''
    startAll;

    $server->waitForUnit("tomcat");
    $server->sleep(30); # Dirty, but it takes a while before Tomcat handles to requests properly
    $client->waitForUnit("network.target");
    $client->succeed("curl --fail http://server/examples/servlets/servlet/HelloWorldExample");
    $client->succeed("curl --fail http://server/examples/jsp/jsp2/simpletag/hello.jsp");
  '';

}
