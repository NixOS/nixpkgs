{ lib, ... }:

{
  name = "glances";

  nodes = {
    machine_default =
      { pkgs, ... }:
      {
        services.glances = {
          enable = true;
        };
      };

    machine_custom_port =
      { pkgs, ... }:
      {
        services.glances = {
          enable = true;
          port = 5678;
        };
      };

    machine_password =
      { pkgs, ... }:
      {
        services.glances = {
          enable = true;
          passwordFile = pkgs.writeText "glances-password" "secret-password\n";
        };
      };
  };

  testScript = ''
    machine_default.start()
    machine_default.wait_for_unit("glances.service")
    machine_default.wait_for_open_port(61208)

    machine_custom_port.start()
    machine_custom_port.wait_for_unit("glances.service")
    machine_custom_port.wait_for_open_port(5678)

    machine_password.start()
    machine_password.wait_for_unit("glances.service")
    machine_password.wait_for_open_port(61208)

    # The status endpoint is reachable without authentication
    machine_password.succeed("curl -fs http://127.0.0.1:61208/api/4/status")

    # Sensitive endpoints require authentication
    machine_password.fail("curl -fs http://127.0.0.1:61208/api/4/pluginslist")
    machine_password.fail("curl -fs -u glances:wrong-password http://127.0.0.1:61208/api/4/pluginslist")

    # The password read from services.glances.passwordFile is accepted
    machine_password.succeed(
      "curl -fs -u glances:secret-password http://127.0.0.1:61208/api/4/pluginslist"
    )
  '';

  meta.maintainers = [ lib.maintainers.claha ];
}
