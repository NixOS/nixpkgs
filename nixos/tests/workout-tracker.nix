import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "workout-tracker";

    meta.maintainers = with lib.maintainers; [ bhankas ];

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;

        services.workout-tracker.enable = true;
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("workout-tracker.service")
      # wait for workout-tracker to fully come up

      with subtest("workout-tracker service starts"):
          machine.wait_until_succeeds(
              "curl -sSfL http://localhost:8080/ > /dev/null",
              timeout=30
          )
    '';
  }
)
