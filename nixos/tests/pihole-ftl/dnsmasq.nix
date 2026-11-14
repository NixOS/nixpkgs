let
  port = "9077";
in
{
  name = "pihole-ftl-dnsmasq";

  nodes.machine = {
    services.pihole-ftl = {
      enable = true;
      useDnsmasqConfig = true;
      openFirewallWebserver = true;
      settings.webserver.port = "${port},[::]:${port}";
    };
  };

  testScript = ''
    import json

    start_all()
    machine.wait_for_unit("pihole-ftl.service")
    machine.wait_for_open_port(${port}, addr="127.0.0.1")
    machine.wait_for_open_port(${port}, addr="::1")
    response = machine.succeed("curl --silent --show-error --globoff http://[::1]:${port}/api/auth")
    assert "session" in json.loads(response)
  '';
}
