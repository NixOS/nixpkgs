{ pkgs, ... }:
{
  name = "octoapp";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ imadnyc ];
  };

  nodes = {
    printer =
      { config, pkgs, ... }:
      {
        services.octoapp.enable = true;

        services.moonraker = {
          enable = true;
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
          settings = { };
        };
      };
  };

  testScript = ''
    printer.start()

    printer.wait_for_unit("klipper.service")
    printer.wait_for_unit("moonraker.service")
    printer.wait_for_unit("octoapp.service")
  '';
}
