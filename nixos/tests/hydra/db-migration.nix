{ system ? builtins.currentSystem, ... }:

let inherit (import ./common.nix { inherit system; }) baseConfig; in

{ mig = import ../make-test-python.nix ({ pkgs, lib, ... }: {
    name = "hydra-db-migration";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ ma27 ];
    };

    nodes = {
      original = { pkgs, lib, ... }: {
        imports = [ baseConfig ];

        # An older version of Hydra before the db change
        # for testing purposes.
        services.hydra.package = pkgs.hydra-migration.overrideAttrs (old: {
          inherit (old) pname;
          version = "2020-02-06";
          src = pkgs.fetchFromGitHub {
            owner = "NixOS";
            repo = "hydra";
            rev = "2b4f14963b16b21ebfcd6b6bfa7832842e9b2afc";
            sha256 = "16q0cffcsfx5pqd91n9k19850c1nbh4vvbd9h8yi64ihn7v8bick";
          };
        });
      };

      migration_phase1 = { pkgs, lib, ... }: {
        imports = [ baseConfig ];
        services.hydra.package = pkgs.hydra-migration;
      };

      finished = { pkgs, lib, ... }: {
        imports = [ baseConfig ];
        services.hydra.package = pkgs.hydra-unstable;
      };
    };

    testScript = { nodes, ... }: let
      next = nodes.migration_phase1.config.system.build.toplevel;
      finished = nodes.finished.config.system.build.toplevel;
    in ''
      original.start()
      original.wait_for_unit("multi-user.target")
      original.wait_for_unit("postgresql.service")
      original.wait_for_unit("hydra-init.service")
      original.require_unit_state("hydra-queue-runner.service")
      original.require_unit_state("hydra-evaluator.service")
      original.require_unit_state("hydra-notify.service")
      original.succeed("hydra-create-user admin --role admin --password admin")
      original.wait_for_open_port(3000)
      original.succeed("create-trivial-project.sh")
      original.wait_until_succeeds(
          'curl -L -s http://localhost:3000/build/1 -H "Accept: application/json" |  jq .buildstatus | xargs test 0 -eq'
      )

      out = original.succeed("su -l postgres -c 'psql -d hydra <<< \"\\d+ jobs\" -A'")
      assert "jobset_id" not in out

      original.succeed(
          "${next}/bin/switch-to-configuration test >&2"
      )
      original.wait_for_unit("hydra-init.service")

      out = original.succeed("su -l postgres -c 'psql -d hydra <<< \"\\d+ jobs\" -A'")
      assert "jobset_id|integer|||" in out

      original.succeed("hydra-backfill-ids")

      original.succeed(
          "${finished}/bin/switch-to-configuration test >&2"
      )
      original.wait_for_unit("hydra-init.service")

      out = original.succeed("su -l postgres -c 'psql -d hydra <<< \"\\d+ jobs\" -A'")
      assert "jobset_id|integer||not null|" in out

      original.wait_until_succeeds(
          'curl -L -s http://localhost:3000/build/1 -H "Accept: application/json" |  jq .buildstatus | xargs test 0 -eq'
      )

      original.shutdown()
    '';
  });
}
