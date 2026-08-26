{ pkgs, ... }:
{
  name = "moonraker";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ zhaofengli ];
  };

  nodes = {
    printer =
      { config, pkgs, ... }:
      {
        security.polkit.enable = true;

        services.moonraker = {
          enable = true;
          allowSystemControl = true;

          settings = {
            authorization = {
              trusted_clients = [
                "127.0.0.0/8"
                "::1/128"
              ];
            };
          };
        };

        services.klipper = {
          enable = true;

          user = "moonraker";
          group = "moonraker";

          # No mcu configured so won't even enter `ready` state
          settings = { };
        };
      };
  };

  testScript = ''
    printer.start()

    printer.wait_for_unit("klipper.service")
    printer.wait_for_unit("moonraker.service")
    printer.wait_until_succeeds("curl http://localhost:7125/printer/info | grep -v 'Not Found' >&2", timeout=30)

    with subtest("Check that we can perform system-level operations"):
        printer.succeed("curl -X POST http://localhost:7125/machine/services/stop?service=klipper | grep ok >&2")
        printer.wait_until_succeeds("systemctl --no-pager show klipper.service | grep ActiveState=inactive", timeout=10)
  '';
}
