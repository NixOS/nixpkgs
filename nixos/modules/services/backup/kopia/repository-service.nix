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

      accessKeyId = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          AWS access key ID for S3 authentication.
          Mutually exclusive with {option}`accessKeyIdFile`.

          ::: {.warning}
          This value will be stored in the Nix store in plain text.
          Prefer {option}`accessKeyIdFile` instead.
          :::
        '';
      };

      accessKeyIdFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the AWS access key ID.
          Read at runtime for secrets management.
          Mutually exclusive with {option}`accessKeyId`.
        '';
      };

      secretAccessKey = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          AWS secret access key for S3 authentication.
          Mutually exclusive with {option}`secretAccessKeyFile`.

          ::: {.warning}
          This value will be stored in the Nix store in plain text.
          Prefer {option}`secretAccessKeyFile` instead.
          :::
        '';
      };

      secretAccessKeyFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the AWS secret access key.
          Read at runtime for secrets management.
          Mutually exclusive with {option}`secretAccessKey`.
        '';
      };

      sessionToken = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          AWS session token for temporary credentials.
          Mutually exclusive with {option}`sessionTokenFile`.

          ::: {.warning}
          This value will be stored in the Nix store in plain text.
          Prefer {option}`sessionTokenFile` instead.
          :::
        '';
      };

      sessionTokenFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the AWS session token.
          Read at runtime for secrets management.
          Mutually exclusive with {option}`sessionToken`.
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

      password = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          SFTP password for authentication.
          Mutually exclusive with {option}`passwordFile`.

          ::: {.warning}
          This password will be stored in the Nix store in plain text.
          Prefer {option}`passwordFile` or {option}`keyFile` instead.
          :::
        '';
      };

      passwordFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the SFTP password.
          Mutually exclusive with {option}`password`.

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

      password = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          WebDAV password for authentication.
          Mutually exclusive with {option}`passwordFile`.

          ::: {.warning}
          This password will be stored in the Nix store in plain text.
          Prefer {option}`passwordFile` instead.
          :::
        '';
      };

      passwordFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to a file containing the WebDAV password.
          Read at runtime for secrets management.
          Mutually exclusive with {option}`password`.
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
      # Generate a shell snippet that sets a variable from either a literal value or a file.
      # If both are null, returns the empty string.
      mkCredentialExport =
        {
          varName,
          value,
          valueFile,
          export ? true,
        }:
        let
          prefix = if export then "export " else "";
        in
        if value != null then
          "${prefix}${varName}=${lib.escapeShellArg value}"
        else if valueFile != null then
          ''${prefix}${varName}="$(cat ${lib.escapeShellArg valueFile})"''
        else
          "";

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
                assertion = s3.accessKeyId != null || s3.accessKeyIdFile != null;
                message = "${prefix}: one of repository.s3.accessKeyId or repository.s3.accessKeyIdFile must be set";
              }
              {
                assertion = s3.secretAccessKey != null || s3.secretAccessKeyFile != null;
                message = "${prefix}: one of repository.s3.secretAccessKey or repository.s3.secretAccessKeyFile must be set";
              }
              # mutual exclusive options
              {
                assertion = s3.accessKeyId == null || s3.accessKeyIdFile == null;
                message = "services.kopia.backups.${name}: repository.s3.accessKeyId and repository.s3.accessKeyIdFile are mutually exclusive";
              }
              {
                assertion = s3.accessKeyId == null || s3.accessKeyIdFile == null;
                message = "services.kopia.backups.${name}: repository.s3.accessKeyId and repository.s3.accessKeyIdFile are mutually exclusive";
              }
              {
                assertion = s3.secretAccessKey == null || s3.secretAccessKeyFile == null;
                message = "services.kopia.backups.${name}: repository.s3.secretAccessKey and repository.s3.secretAccessKeyFile are mutually exclusive";
              }
              {
                assertion = s3.sessionToken == null || s3.sessionTokenFile == null;
                message = "services.kopia.backups.${name}: repository.s3.sessionToken and repository.s3.sessionTokenFile are mutually exclusive";
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
                assertion = sftp.keyFile != null || sftp.password != null || sftp.passwordFile != null;
                message = "${prefix}: at least one of repository.sftp.keyFile, repository.sftp.password, or repository.sftp.passwordFile must be set";
              }

              # assert mutualExclusion options, mainly for secret handling
              {
                assertion = sftp.host == null || sftp.hostFile == null;
                message = "services.kopia.backups.${name}: repository.sftp.host and repository.sftp.hostFile are mutually exclusive";
              }
              {
                assertion = sftp.password == null || sftp.passwordFile == null;
                message = "services.kopia.backups.${name}: repository.sftp.password and repository.sftp.passwordFile are mutually exclusive";
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

              # assert mutualExclusion options, mainly for secret handling
              {
                assertion = webdav.url == null || webdav.urlFile == null;
                message = "services.kopia.backups.${name}: repository.webdav.url and repository.webdav.urlFile are mutually exclusive";
              }
              {
                assertion = webdav.username == null || webdav.usernameFile == null;
                message = "services.kopia.backups.${name}: repository.webdav.username and repository.webdav.usernameFile are mutually exclusive";
              }
              {
                assertion = webdav.password == null || webdav.passwordFile == null;
                message = "services.kopia.backups.${name}: repository.webdav.password and repository.webdav.passwordFile are mutually exclusive";
              }
            ]
          )
        ) cfg.backups
      );

      warnings = lib.flatten (
        lib.mapAttrsToList (
          name: backup:
          lib.optionals (backup.repository ? s3) (
            let
              s3 = backup.repository.s3;
            in

            (lib.optional (s3.accessKeyId != null)
              "services.kopia.backups.${name}: repository.s3.accessKeyId is set as plain text and will be world-readable in the Nix store. Consider using repository.s3.accessKeyIdFile instead."
            )
            ++ (lib.optional (s3.secretAccessKey != null)
              "services.kopia.backups.${name}: repository.s3.secretAccessKey is set as plain text and will be world-readable in the Nix store. Consider using repository.s3.secretAccessKeyFile instead."
            )
            ++ (lib.optional (s3.sessionToken != null)
              "services.kopia.backups.${name}: repository.s3.sessionToken is set as plain text and will be world-readable in the Nix store. Consider using repository.s3.sessionTokenFile instead."
            )
          )
          ++ lib.optionals (backup.repository ? sftp) (

            (lib.optional (backup.repository.sftp.password != null)
              "services.kopia.backups.${name}: repository.sftp.password is set as plain text and will be world-readable in the Nix store. Consider using repository.sftp.passwordFile instead."
            )
          )
          ++ lib.optionals (backup.repository ? webdav) (
            (lib.optional (backup.repository.webdav.password != null)
              "services.kopia.backups.${name}: repository.webdav.password is set as plain text and will be world-readable in the Nix store. Consider using repository.webdav.passwordFile instead."
            )
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
                ${mkCredentialExport {
                  varName = "AWS_ACCESS_KEY_ID";
                  value = s3.accessKeyId;
                  valueFile = s3.accessKeyIdFile;
                }}
                ${mkCredentialExport {
                  varName = "AWS_SECRET_ACCESS_KEY";
                  value = s3.secretAccessKey;
                  valueFile = s3.secretAccessKeyFile;
                }}
                ${mkCredentialExport {
                  varName = "AWS_SESSION_TOKEN";
                  value = s3.sessionToken;
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
                ${mkCredentialExport {
                  varName = "SFTP_HOST";
                  value = sftp.host;
                  valueFile = sftp.hostFile;
                  export = false;
                }}
                REPO_ARGS="--path ${lib.escapeShellArg sftp.path} --host $SFTP_HOST --port ${toString sftp.port} --username ${lib.escapeShellArg sftp.username}"
                ${lib.optionalString (sftp.keyFile != null) ''
                  REPO_ARGS="$REPO_ARGS --keyfile ${lib.escapeShellArg sftp.keyFile}"
                ''}
                ${lib.optionalString (sftp.knownHostsFile != null) ''
                  REPO_ARGS="$REPO_ARGS --known-hosts ${lib.escapeShellArg sftp.knownHostsFile}"
                ''}
                # TODO: waiting upstream fix(https://github.com/kopia/kopia/issues/5180)
                ${lib.optionalString (sftp.password != null) ''
                  REPO_ARGS="$REPO_ARGS --sftp-password ${lib.escapeShellArg sftp.password}"
                ''}
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
                ${mkCredentialExport {
                  varName = "WEBDAV_URL";
                  value = dav.url;
                  valueFile = dav.urlFile;
                  export = false;
                }}
                REPO_ARGS="--url $WEBDAV_URL"
                ${lib.optionalString dav.flat ''
                  REPO_ARGS="$REPO_ARGS --flat"
                ''}
                ${lib.optionalString dav.atomicWrites ''
                  REPO_ARGS="$REPO_ARGS --atomic-writes"
                ''}
                ${mkCredentialExport {
                  varName = "KOPIA_WEBDAV_USERNAME";
                  value = dav.username;
                  valueFile = dav.usernameFile;
                }}
                ${mkCredentialExport {
                  varName = "KOPIA_WEBDAV_PASSWORD";
                  value = dav.password;
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
        lib.nameValuePair (helpers.mkUnitBaseName "repository" name) {
          description = "Kopia repository connection for ${name}";
          restartIfChanged = false;
          wants = lib.mkIf needsNetwork [ "network-online.target" ];
          after = lib.mkIf needsNetwork [ "network-online.target" ];
          environment = helpers.mkKopiaEnvironment name;
          serviceConfig = helpers.mkBaseServiceConfig name backup // {
            RemainAfterExit = true;
            ExecStart = startScript;
            ExecStop = "${kopiaExe} repository disconnect";
          };
        }
      ) cfg.backups;
    };
}
