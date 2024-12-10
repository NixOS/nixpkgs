{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let

  inherit (import ./common.nix { inherit system; }) baseConfig;

  hydraPkgs = {
    inherit (pkgs) hydra_unstable;
  };

  makeHydraTest =
    with pkgs.lib;
    name: package:
    makeTest {
      name = "hydra-${name}";
      meta = with pkgs.lib.maintainers; {
        maintainers = [ lewo ];
      };

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ baseConfig ];
          services.hydra = { inherit package; };
        };

      testScript = ''
        # let the system boot up
        machine.wait_for_unit("multi-user.target")
        # test whether the database is running
        machine.wait_for_unit("postgresql.service")
        # test whether the actual hydra daemons are running
        machine.wait_for_unit("hydra-init.service")
        machine.require_unit_state("hydra-queue-runner.service")
        machine.require_unit_state("hydra-evaluator.service")
        machine.require_unit_state("hydra-notify.service")

        machine.succeed("hydra-create-user admin --role admin --password admin")

        # create a project with a trivial job
        machine.wait_for_open_port(3000)

        # make sure the build as been successfully built
        machine.succeed("create-trivial-project.sh")

        machine.wait_until_succeeds(
            'curl -L -s http://localhost:3000/build/1 -H "Accept: application/json" |  jq .buildstatus | xargs test 0 -eq'
        )

        machine.wait_until_succeeds(
            'journalctl -eu hydra-notify.service -o cat | grep -q "sending mail notification to hydra@localhost"'
        )
      '';
    };

in

mapAttrs makeHydraTest hydraPkgs
