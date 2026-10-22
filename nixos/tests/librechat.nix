# Run this test with NIXPKGS_ALLOW_UNFREE=1
{ lib, ... }:
{
  name = "librechat";

  meta.maintainers = with lib.maintainers; [
    gepbird
    niklaskorz
    rrvsh
  ];

  nodes.machine =
    { pkgs, ... }:
    let
      # !!! Don't do this with real keys. The /nix store is world-readable!
      credsKeyFile = pkgs.writeText "librechat-creds-key" "6d6deb03cdfb27ea454f6b9ddd42494bdce4af25d50d8aee454ddce583690cc5";
      credsIvFile = pkgs.writeText "librechat-creds-iv" "7c09a571f65ac793611685cc9ab1dbe7";
      jwtSecret = pkgs.writeText "librechat-jwt-secret" "29c4dc7f7de15306accf5eddb4cb8a70eb233d9fba4301f8f47f14c8c047ac81";
      jwtRefreshSecret = pkgs.writeText "librechat-jwt-refresh-secret" "f2c1685561f2f570b3e7955df267b5c602ee099f14dc5caa0dacc320580ea180";
      meilisearchMasterKeyFile = pkgs.writeText "meilisearch-master-key" "xHkP3Bzcf98fw7FiSCR82g5ULLGrXc4frK1qkEfN8St/3kJZ";
    in
    {
      services.librechat = {
        enable = true;
        env = {
          ALLOW_REGISTRATION = true;
        };
        credentials = {
          # The following were randomly generated with https://www.librechat.ai/toolkit/creds_generator
          CREDS_KEY = credsKeyFile;
          CREDS_IV = credsIvFile;
          JWT_SECRET = jwtSecret;
          JWT_REFRESH_SECRET = jwtRefreshSecret;
        };
        enableLocalDB = true;
        meilisearch.enable = true;
      };

      services.meilisearch.masterKeyFile = meilisearchMasterKeyFile;
    };

  testScript = ''
    machine.start()

    machine.succeed("grep -qF 'ALLOW_REGISTRATION=true' /etc/systemd/system/librechat.service")
    machine.succeed("grep -qF 'SEARCH=true' /etc/systemd/system/librechat.service")
    machine.succeed("grep -qF 'MEILI_HOST=http://localhost:7700' /etc/systemd/system/librechat.service")
    machine.succeed("grep -qG 'MEILI_MASTER_KEY_FILE:/nix/store/.*meilisearch-master-key' /etc/systemd/system/librechat.service")

    machine.wait_for_unit("librechat.service")
    machine.wait_for_open_port(3080)

    machine.succeed("curl --fail http://localhost:3080/")

    machine.shutdown()
  '';
}
