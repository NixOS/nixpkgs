import ./make-test.nix ({ pkgs, ...} : {
  name = "tomcat";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  nodes = {
    server =
      { ... }:

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
    $client->waitForUnit("network.target");
    $client->waitUntilSucceeds("curl --fail http://server/examples/servlets/servlet/HelloWorldExample");
    $client->waitUntilSucceeds("curl --fail http://server/examples/jsp/jsp2/simpletag/hello.jsp");
  '';
})
