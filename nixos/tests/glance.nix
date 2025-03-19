{ config, lib, ... }:

{
  name = "glance";

  nodes = {
    machine_default =
      { pkgs, ... }:
      {
        services.glance = {
          enable = true;
        };
      };

    machine_custom_port =
      { pkgs, ... }:
      {
        services.glance = {
          enable = true;
          settings.server.port = 5678;
        };
      };
  };

  extraPythonPackages =
    p: with p; [
      beautifulsoup4
      types-beautifulsoup4
    ];

  testScript = ''
    from bs4 import BeautifulSoup

    machine_default.start()
    machine_default.wait_for_unit("glance.service")
    machine_default.wait_for_open_port(8080)

    machine_custom_port.start()
    machine_custom_port.wait_for_unit("glance.service")
    machine_custom_port.wait_for_open_port(5678)

    soup = BeautifulSoup(machine_default.succeed("curl http://localhost:8080"))
    expected_version = "${config.nodes.machine_default.services.glance.package.version}"
    assert any(a.text == expected_version for a in soup.select(".footer a"))
  '';

  meta.maintainers = [ lib.maintainers.drupol ];
}
