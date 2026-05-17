{ lib, ... }:

{
  name = "honk-server";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.honk = {
          enable = true;
          host = "0.0.0.0";
          port = 8080;
          username = "username";
          passwordFile = "${pkgs.writeText "honk-password" "secure"}";
          servername = "servername";
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("honk.service")
    machine.wait_for_open_port(8080)

    machine.stop_job("honk")
    machine.wait_for_closed_port(8080)

    machine.start_job("honk")
    machine.wait_for_open_port(8080)
  '';

  meta.maintainers = [ ];
}
