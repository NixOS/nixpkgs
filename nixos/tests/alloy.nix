import ./make-test-python.nix (
  { lib, pkgs, ... }:

  let
    nodes = {
      machine = {
        services.alloy = {
          enable = true;
        };
        environment.etc."alloy/config.alloy".text = "";
      };
    };
  in
  {
    name = "alloy";

    meta = with lib.maintainers; {
      maintainers = [
        flokli
        hbjydev
      ];
    };

    inherit nodes;

    testScript = ''
      start_all()

      machine.wait_for_unit("alloy.service")
      machine.wait_for_open_port(12345)
      machine.succeed(
          "curl -sSfN http://127.0.0.1:12345/-/healthy"
      )
      machine.shutdown()
    '';
  }
)
