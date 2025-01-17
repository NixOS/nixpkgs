import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {

    name = "bpftune";

    meta = {
      maintainers = with lib.maintainers; [ nickcao ];
    };

    nodes = {
      machine =
        { pkgs, ... }:
        {
          services.bpftune.enable = true;
        };
    };

    testScript = ''
      machine.wait_for_unit("bpftune.service")
      machine.wait_for_console_text("bpftune works")
    '';

  }
)
