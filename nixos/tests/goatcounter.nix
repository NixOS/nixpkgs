import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "goatcounter";

    meta.maintainers = with lib.maintainers; [ bhankas ];

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;

        services.goatcounter = {
          enable = true;
          proxy = true;
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("goatcounter.service")
      # wait for goatcounter to fully come up

      with subtest("goatcounter service starts"):
          machine.wait_until_succeeds(
              "curl -sSfL http://localhost:8081/ > /dev/null",
              timeout=30
          )
    '';
  }
)
