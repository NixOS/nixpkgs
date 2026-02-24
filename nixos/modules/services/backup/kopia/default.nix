{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./repository-service.nix
    ./policy-service.nix
    ./snapshot-service.nix
    ./web-service.nix
  ];

  options.services.kopia.package = lib.mkPackageOption pkgs "kopia" { };

  options.services.kopia.backups = lib.mkOption {
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
                Path to a file containing the repository password (KOPIA_PASSWORD).
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
        # Simple filesystem backup.
        localbackup = {
          repository.filesystem.path = "/mnt/backup";
          passwordFile = "/run/secrets/kopia-password";
          paths = [ "/home" "/var/lib/postgresql" ];
          policy.retention.keepDaily = 7;
          policy.retention.keepWeekly = 4;
          policy.compression = "zstd";
        };

        # SFTP example: backs up to a remote server over SSH/SFTP.
        # Key-based authentication is preferred for security.
        sftp-backup = {
          repository.sftp = {
            # Use host for a plain hostname, or hostFile to read it from a file
            # at runtime (e.g. for secrets management). They are mutually exclusive.
            host = "backup.example.com";
            path = "/backup/kopia-repo";
            username = "kopia";
            keyFile = "/root/.ssh/id_ed25519";
            knownHostsFile = "/root/.ssh/known_hosts";
          };
          passwordFile = "/run/secrets/kopia-password";
          paths = [ "/home" "/var/lib" ];
          policy.retention.keepDaily = 7;
          policy.retention.keepWeekly = 4;
          policy.compression = "zstd";
        };

        # WebDAV example: backs up to a WebDAV server.
        webdav-backup = {
          repository.webdav = {
            url = "https://webdav.example.com/backup/kopia";
            # Use passwordFile to read credentials from a file at runtime.
            usernameFile = "/run/secrets/webdav-username";
            passwordFile = "/run/secrets/webdav-password";
          };
          passwordFile = "/run/secrets/kopia-password";
          paths = [ "/home" ];
          policy.retention.keepDaily = 7;
          policy.compression = "zstd";
        };
      }
    '';
  };
}
