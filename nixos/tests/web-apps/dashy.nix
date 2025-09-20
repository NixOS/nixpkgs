{ lib, ... }:
{
  name = "dashy";
  meta.maintainers = [ lib.maintainers.therealgramdalf ];

  nodes.machine =
    { config, ... }:
    {
      services.dashy = {
        enable = true;
        virtualHost = {
          enableNginx = true;
          domain = "dashy.local";
        };
      };

      networking.extraHosts = "127.0.0.1 dashy.local";

      services.nginx.virtualHosts."${config.services.dashy.virtualHost.domain}".listen = [
        {
          addr = "127.0.0.1";
          port = 80;
        }
      ];
    };

  # Note that without javascript, the title is always `Dashy` regardless of your `settings.pageInfo.title`
  # This test could be improved to include checking that user settings are applied properly with proper tools/requests
  # and/or by checking the static site files directly instead
  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    actual = machine.succeed("curl -v --stderr - http://dashy.local/", timeout=10)
    expected = "<title>Dashy</title>"
    assert expected in actual, \
      f"unexpected reply from Dashy, expected: '{expected}' got: '{actual}'"
  '';
}
