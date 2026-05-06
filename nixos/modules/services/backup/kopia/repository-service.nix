{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kopia;
  helpers = import ./helpers.nix { inherit lib; };

  filesystemSubmodule = lib.types.submodule {
    options = {
      path = lib.mkOption {
        type = lib.types.str;
        description = ''
          Path to local filesystem directory for the repository.
        '';
        example = "/mnt/backup";
      };
    };
  };

  s3Submodule = lib.types.submodule {
    options = {
      bucket = lib.mkOption {
        type = lib.types.str;
        description = ''
          S3 bucket name.
        '';
      };

      endpoint = lib.mkOption {
        type = lib.types.str;
        default = "s3.amazonaws.com";
        description = ''
          S3 endpoint URL.
        '';
      };

      region = lib.mkOption {
        type = lib.types.str;
        default = "us-east-1";
        description = ''
          S3 region.
        '';
      };

      disableTLS = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Disable TLS for S3 connections.
        '';
      };

      accessKeyIdFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the AWS access key ID.
          Read at runtime for secrets management.

          For tests or examples, this can be provided with a store path:

          ```nix
          accessKeyIdFile = pkgs.writeText "kopia-s3-access-key-id" "my-super-safe-secret";
          ```

          This still stores the secret in the Nix store. For production
          secrets, prefer a runtime secret file such as `/run/secrets/...`.
        '';
      };

      secretAccessKeyFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the AWS secret access key.
          Read at runtime for secrets management.

          For tests or examples, this can be provided with a store path:

          ```nix
          secretAccessKeyFile = pkgs.writeText "kopia-s3-secret-access-key" "my-super-safe-secret";
          ```

          This still stores the secret in the Nix store. For production
          secrets, prefer a runtime secret file such as `/run/secrets/...`.
        '';
      };

      sessionTokenFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the AWS session token.
          Read at runtime for secrets management.

          For tests or examples, this can be provided with a store path:

          ```nix
          sessionTokenFile = pkgs.writeText "kopia-s3-session-token" "my-super-safe-secret";
          ```

          This still stores the secret in the Nix store. For production
          secrets, prefer a runtime secret file such as `/run/secrets/...`.
        '';
      };
    };
  };

  sftpSubmodule = lib.types.submodule {
    options = {
      host = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          SFTP server hostname.
          Mutually exclusive with {option}`hostFile`.
        '';
      };

      hostFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the SFTP server hostname.
          Read at runtime for secrets management.
          Mutually exclusive with {option}`host`.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 22;
        description = ''
          SSH port for the SFTP connection.
        '';
      };

      username = lib.mkOption {
        type = lib.types.str;
        description = ''
          SSH username for the SFTP connection.
        '';
      };

      path = lib.mkOption {
        type = lib.types.str;
        description = ''
          Remote directory path for the repository on the SFTP server.
        '';
      };

      keyFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to SSH private key file for authentication.
          Preferred over password authentication.
        '';
      };

      passwordFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the SFTP password.

          For tests or examples, this can be provided with a store path:

          ```nix
          passwordFile = pkgs.writeText "kopia-sftp-password" "my-super-safe-secret";
          ```

          This still stores the password in the Nix store. For production
          secrets, prefer a runtime secret file such as `/run/secrets/...`.

          ::: {.warning}
          Password authentication is less secure than key-based authentication.
          Prefer setting {option}`keyFile` with an SSH private key instead.
          :::
        '';
      };

      knownHostsFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to SSH known_hosts file for host key verification.
        '';
      };
    };
  };

  webdavSubmodule = lib.types.submodule {
    options = {
      url = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          WebDAV server URL.
          Mutually exclusive with {option}`urlFile`.
        '';
        example = "https://webdav.example.com/backup";
      };

      urlFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the WebDAV server URL.
          Read at runtime for secrets management.
          Mutually exclusive with {option}`url`.
        '';
      };

      username = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          WebDAV username for authentication.
          Mutually exclusive with {option}`usernameFile`.
        '';
      };

      usernameFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the WebDAV username.
          Read at runtime for secrets management.
          Mutually exclusive with {option}`username`.
        '';
      };

      passwordFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the WebDAV password.
          Read at runtime for secrets management.

          For tests or examples, this can be provided with a store path:

          ```nix
          passwordFile = pkgs.writeText "kopia-webdav-password" "my-super-safe-secret";
          ```

          This still stores the password in the Nix store. For production
          secrets, prefer a runtime secret file such as `/run/secrets/...`.
        '';
      };

      flat = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use flat directory structure on the WebDAV server.
        '';
      };

      atomicWrites = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Assume the WebDAV provider implements atomic writes.
        '';
      };
    };
  };
in
{
  options.services.kopia.backups = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          repository = lib.mkOption {
            type = lib.types.attrTag {
              filesystem = lib.mkOption {
                type = filesystemSubmodule;
                description = ''
                  Local filesystem repository backend.
                '';
              };
              s3 = lib.mkOption {
                type = s3Submodule;
                description = ''
                  S3 repository backend.
                '';
              };
              sftp = lib.mkOption {
                type = sftpSubmodule;
                description = ''
                  SFTP repository backend.
                '';
              };
              webdav = lib.mkOption {
                type = webdavSubmodule;
                description = ''
                  WebDAV repository backend.
                '';
              };
            };
            description = ''
              Repository backend configuration. Exactly one backend must be selected.
            '';
          };
        };
      }
    );
  };

  config =
    let
      # Generate a shell snippet that sets a variable from a file.
      # If the file is null, returns the empty string.
      mkCredentialFileExport =
        {
          varName,
          valueFile,
          export ? true,
        }:
        let
          prefix = if export then "export " else "";
        in
        if valueFile != null then ''${prefix}${varName}="$(cat ${lib.escapeShellArg valueFile})"'' else "";

      # Generate the connect-or-create script body for a given backend type and args variable.
      mkConnectOrCreate = kopiaExe: backendType: argsVar: ''
        if ! ${kopiaExe} repository connect ${backendType} ''$${argsVar}; then
          ${kopiaExe} repository create ${backendType} ''$${argsVar}
        fi
      '';
    in
    lib.mkIf (cfg.backups != { }) {
      assertions = lib.flatten (
        lib.mapAttrsToList (
          name: backup:
          let
            prefix = "services.kopia.backups.${name}";

          in
          lib.optionals (backup.repository ? s3) (
            let
              s3 = backup.repository.s3;
            in
            [
              {
                assertion = s3.accessKeyIdFile != null;
                message = "${prefix}: repository.s3.accessKeyIdFile must be set";
              }
              {
                assertion = s3.secretAccessKeyFile != null;
                message = "${prefix}: repository.s3.secretAccessKeyFile must be set";
              }
            ]
          )
          ++ lib.optionals (backup.repository ? sftp) (
            let
              sftp = backup.repository.sftp;
            in
            [
              # assert required options
              {
                assertion = sftp.host != null || sftp.hostFile != null;
                message = "${prefix}: one of repository.sftp.host or repository.sftp.hostFile must be set";
              }
              {
                assertion = sftp.keyFile != null || sftp.passwordFile != null;
                message = "${prefix}: at least one of repository.sftp.keyFile or repository.sftp.passwordFile must be set";
              }

              {
                assertion = sftp.host == null || sftp.hostFile == null;
                message = "services.kopia.backups.${name}: repository.sftp.host and repository.sftp.hostFile are mutually exclusive";
              }
            ]
          )
          ++ lib.optionals (backup.repository ? webdav) (
            let
              webdav = backup.repository.webdav;
            in
            [
              # assert required options
              {
                assertion = webdav.url != null || webdav.urlFile != null;
                message = "${prefix}: one of repository.webdav.url or repository.webdav.urlFile must be set";
              }

              {
                assertion = webdav.url == null || webdav.urlFile == null;
                message = "services.kopia.backups.${name}: repository.webdav.url and repository.webdav.urlFile are mutually exclusive";
              }
              {
                assertion = webdav.username == null || webdav.usernameFile == null;
                message = "services.kopia.backups.${name}: repository.webdav.username and repository.webdav.usernameFile are mutually exclusive";
              }
            ]
          )
        ) cfg.backups
      );

      systemd.services = lib.mapAttrs' (
        name: backup:
        let
          kopiaExe = lib.getExe cfg.package;
          repo = backup.repository;
          needsNetwork = !(repo ? filesystem);

          mkScriptBody =
            if repo ? filesystem then
              ''
                REPO_ARGS="--path ${lib.escapeShellArg repo.filesystem.path}"
                ${mkConnectOrCreate kopiaExe "filesystem" "REPO_ARGS"}
              ''
            else if repo ? s3 then
              let
                s3 = repo.s3;
              in
              ''
                ${mkCredentialFileExport {
                  varName = "AWS_ACCESS_KEY_ID";
                  valueFile = s3.accessKeyIdFile;
                }}
                ${mkCredentialFileExport {
                  varName = "AWS_SECRET_ACCESS_KEY";
                  valueFile = s3.secretAccessKeyFile;
                }}
                ${mkCredentialFileExport {
                  varName = "AWS_SESSION_TOKEN";
                  valueFile = s3.sessionTokenFile;
                }}
                REPO_ARGS="--bucket ${lib.escapeShellArg s3.bucket} --endpoint ${lib.escapeShellArg s3.endpoint} --region ${lib.escapeShellArg s3.region}"
                ${lib.optionalString s3.disableTLS ''
                  REPO_ARGS="$REPO_ARGS --disable-tls"
                ''}
                ${mkConnectOrCreate kopiaExe "s3" "REPO_ARGS"}
              ''
            else if repo ? sftp then
              let
                sftp = repo.sftp;
              in
              ''
                ${mkCredentialFileExport {
                  varName = "SFTP_HOST";
                  valueFile = sftp.hostFile;
                  export = false;
                }}
                ${lib.optionalString (sftp.host != null) ''
                  SFTP_HOST=${lib.escapeShellArg sftp.host}
                ''}
                REPO_ARGS="--path ${lib.escapeShellArg sftp.path} --host $SFTP_HOST --port ${toString sftp.port} --username ${lib.escapeShellArg sftp.username}"
                ${lib.optionalString (sftp.keyFile != null) ''
                  REPO_ARGS="$REPO_ARGS --keyfile ${lib.escapeShellArg sftp.keyFile}"
                ''}
                ${lib.optionalString (sftp.knownHostsFile != null) ''
                  REPO_ARGS="$REPO_ARGS --known-hosts ${lib.escapeShellArg sftp.knownHostsFile}"
                ''}
                # TODO: waiting upstream fix(https://github.com/kopia/kopia/issues/5180)
                ${lib.optionalString (sftp.passwordFile != null) ''
                  REPO_ARGS="$REPO_ARGS --sftp-password $(cat ${lib.escapeShellArg sftp.passwordFile})"
                ''}
                ${mkConnectOrCreate kopiaExe "sftp" "REPO_ARGS"}
              ''
            else
              let
                dav = repo.webdav;
              in
              ''
                ${mkCredentialFileExport {
                  varName = "WEBDAV_URL";
                  valueFile = dav.urlFile;
                  export = false;
                }}
                ${lib.optionalString (dav.url != null) ''
                  WEBDAV_URL=${lib.escapeShellArg dav.url}
                ''}
                REPO_ARGS="--url $WEBDAV_URL"
                ${lib.optionalString dav.flat ''
                  REPO_ARGS="$REPO_ARGS --flat"
                ''}
                ${lib.optionalString dav.atomicWrites ''
                  REPO_ARGS="$REPO_ARGS --atomic-writes"
                ''}
                ${mkCredentialFileExport {
                  varName = "KOPIA_WEBDAV_USERNAME";
                  valueFile = dav.usernameFile;
                }}
                ${lib.optionalString (dav.username != null) ''
                  export KOPIA_WEBDAV_USERNAME=${lib.escapeShellArg dav.username}
                ''}
                ${mkCredentialFileExport {
                  varName = "KOPIA_WEBDAV_PASSWORD";
                  valueFile = dav.passwordFile;
                }}
                ${mkConnectOrCreate kopiaExe "webdav" "REPO_ARGS"}
              '';

          startScript = pkgs.writeShellScript "kopia-repository-connect-${name}" ''
            set -euo pipefail
            export KOPIA_PASSWORD="$(cat ${lib.escapeShellArg backup.passwordFile})"

            ${mkScriptBody}
          '';
        in
        lib.nameValuePair "kopia-repository-${name}" {
          description = "Kopia repository connection for ${name}";
          restartIfChanged = false;
          wants = lib.mkIf needsNetwork [ "network-online.target" ];
          after = lib.mkIf needsNetwork [ "network-online.target" ];
          environment = {
            KOPIA_CONFIG_PATH = "/var/lib/kopia/${name}/repository.config";
          };
          serviceConfig = {
            Type = "oneshot";
            User = backup.user;
            StateDirectory = "kopia/${name}";
            PrivateTmp = true;
            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ReadWritePaths = [
              "/var/lib/kopia/${name}"
            ]
            ++ lib.optional (backup.repository ? filesystem) backup.repository.filesystem.path;
          }
          // {
            RemainAfterExit = true;
            ExecStart = startScript;
            ExecStop = "${kopiaExe} repository disconnect";
          };
        }
      ) cfg.backups;
    };
}
