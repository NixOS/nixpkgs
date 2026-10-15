{ lib, pkgs, ... }:

{
  name = "powerdns-recursor";
  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

  nodes.server = {
    services.pdns-recursor.enable = true;
    services.pdns-recursor.api.enable = true;
    services.pdns-recursor.exportHosts = true;
    services.pdns-recursor.settings.webservice.api_key = "supersecret";
    networking.hosts."192.0.2.1" = [ "example.com" ];
  };

  testScript = ''
    with subtest("pdns-recursor is running"):
      server.wait_for_unit("pdns-recursor")
      server.wait_for_open_port(53)

    with subtest("can resolve names"):
      assert "192.0.2.1" in server.succeed("host example.com localhost")

    with subtest("api is working"):
      server.wait_for_open_port(8082)
      server.succeed("curl -f -H 'X-API-Key: supersecret' http://localhost:8082/api/v1/servers")
      server.fail("curl -f http://localhost:8082/api/v1/servers")

    with subtest("metrics are exported"):
      assert "pdns_recursor_" in server.succeed("curl -f -H 'X-API-Key: supersecret' http://localhost:8082/metrics")
  '';
}
