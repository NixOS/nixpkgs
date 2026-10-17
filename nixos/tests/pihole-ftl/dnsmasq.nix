let
  port = "9077";
in
{
  name = "pihole-ftl-dnsmasq";

  nodes.machine = {
    services.pihole-ftl = {
      enable = true;
      useDnsmasqConfig = true;
      settings.webserver.port = port;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("pihole-ftl.service")
    machine.wait_for_open_port(${port})
  '';
}
