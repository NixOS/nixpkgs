{ ... }:
{
  name = "immich-vectorchord-reindex";

  nodes.machine =
    { lib, pkgs, ... }:
    {
      # These tests need a little more juice
      virtualisation = {
        cores = 2;
        memorySize = 2048;
        diskSize = 4096;
      };

      services.immich = {
        enable = true;
        environment.IMMICH_LOG_LEVEL = "verbose";
      };

      services.postgresql.extensions = lib.mkForce (ps: [
        ps.pgvector
        # pin vectorchord to an older version simulate version bump
        (ps.vectorchord.overrideAttrs (prevAttrs': rec {
          version = "0.5.2";
          src = pkgs.fetchFromGitHub {
            owner = "tensorchord";
            repo = "vectorchord";
            tag = version;
            hash = "sha256-KGwiY5t1ivFiYex3D20y3sdiu3CT9LCDd2fPnRE56jM=";
          };

          cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
            inherit src;
            hash = "sha256-Vn3c/xuUpQzERJ74I0qbvufTZtW3goefPa5B/nOUO48=";
          };
        }))
      ]);

      specialisation."immich-vectorchord-upgraded".configuration = {
        # needs to be lower than mkForce, otherwise it does not get rid of the previous version
        services.postgresql.extensions = lib.mkOverride 40 (ps: [
          ps.pgvector
          ps.vectorchord
        ]);
      };

    };

  testScript =
    { nodes, ... }:
    let
      specBase = "${nodes.machine.system.build.toplevel}/specialisation";
      vectorchordUpgraded = "${specBase}/immich-vectorchord-upgraded";
    in
    ''
      def immich_works():
        machine.wait_for_unit("immich-server.service")

        machine.wait_for_open_port(2283) # Server
        machine.wait_for_open_port(3003) # Machine learning
        machine.succeed("curl --fail http://localhost:2283/")

      immich_works()

      machine.succeed("${vectorchordUpgraded}/bin/switch-to-configuration test")

      # just tests that reindexing is triggered
      machine.wait_until_succeeds(
        "journalctl -o cat -u postgresql-setup.service | grep 'REINDEX'"
      )

      immich_works()
    '';
}
