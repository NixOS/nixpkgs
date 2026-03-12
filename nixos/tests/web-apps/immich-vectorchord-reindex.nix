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

      services.postgresql.extensions = lib.mkForce (
        ps:
        let
          # Pin vectorchord to an older version simulate version bump.
          # This version must have a different "schema" version than the latest version in nixpkgs.
          # See version number at https://github.com/tensorchord/VectorChord/blob/1.1.0/crates/vchordrq/src/tuples.rs#L23
          vectorchord =
            (ps.vectorchord.override {
              cargo-pgrx_0_17_0 = pkgs.cargo-pgrx_0_16_0;
            }).overrideAttrs
              (
                finalAttrs: _: {
                  version = "1.0.0";
                  src = pkgs.fetchFromGitHub {
                    owner = "tensorchord";
                    repo = "vectorchord";
                    tag = finalAttrs.version;
                    hash = "sha256-+BOuiinbKPZZaDl9aYsIoZPgvLZ4FA6Rb4/W+lAz4so=";
                  };

                  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                    inherit (finalAttrs) src;
                    hash = "sha256-kwe2x7OTjpdPonZsvnR1C/89D5W/R5JswYF79YcSFEA=";
                  };
                }
              );
        in
        [
          ps.pgvector
          vectorchord
        ]
      );

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
