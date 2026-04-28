{
  lib,
  pkgs,
  ...
}:
{
  meta.maintainers = with lib.maintainers; [ efficacy38 ];

  options.services.kopia = {
    package = lib.mkPackageOption pkgs "kopia" { };

    backups = lib.mkOption {
      description = ''
        Periodic backups to create with Kopia.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              passwordFile = lib.mkOption {
                type = lib.types.str;
                description = ''
                  Path to a file containing the repository password, passed in via `KOPIA_PASSWORD`.

                  For tests or examples, this can be provided with a store path:

                  ```nix
                  passwordFile = pkgs.writeText "kopia-password" "my-super-safe-secret";
                  ```

                  This still stores the password in the Nix store. For production
                  secrets, prefer a runtime secret file such as `/run/secrets/...`.
                '';
                example = "/run/secrets/kopia-password";
              };

              user = lib.mkOption {
                type = lib.types.str;
                default = "root";
                description = ''
                  As which user the backup should run.
                '';
              };

            };
          }
        )
      );
      default = { };
      example = lib.literalExpression ''
        {
          s3-backup = {
            repository.s3 = {
              bucket = "your bucket name";
              endpoint = "s3.region.amazonaws.com";
              accessKeyIdFile = "/run/secrets/s3-access-key";
              secretAccessKeyFile = "/run/secrets/s3-secret-access-key";
            };
            passwordFile = "/run/secrets/kopia-password";
            web = {
              enable = true;
              serverPasswordFile = "/run/secrets/kopia-server-password";
            };
            paths = [ "/persistent" ];
            policy = {
              retention = {
                keepLatest = 5;
                keepDaily = 30;
                keepWeekly = 4;
                keepMonthly = 3;
                keepAnnual = 0;
              };
              compression = "pgzip";
            };
          };
        }
      '';
    };
  };
}
