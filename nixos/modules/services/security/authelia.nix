{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.authelia;

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yml" cfg.settings;

  autheliaOpts =
    with lib;
    { name, ... }:
    {
      options = {
        enable = mkEnableOption "Authelia instance";

        name = mkOption {
          type = types.str;
          default = name;
          description = ''
            Name is used as a suffix for the service name, user, and group.
            By default it takes the value you use for `<instance>` in:
            {option}`services.authelia.<instance>`
          '';
        };

        package = mkPackageOption pkgs "authelia" { };

        user = mkOption {
          default = "authelia-${name}";
          type = types.str;
          description = "The name of the user for this authelia instance.";
        };

        group = mkOption {
          default = "authelia-${name}";
          type = types.str;
          description = "The name of the group for this authelia instance.";
        };

        secrets = mkOption {
          description = ''
            It is recommended you keep your secrets separate from the configuration.
            It's especially important to keep the raw secrets out of your nix configuration,
            as the values will be preserved in your nix store.
            This attribute allows you to configure the location of secret files to be loaded at runtime.

            https://www.authelia.com/configuration/methods/secrets/
          '';
          default = { };
          type = types.submodule {
            options = {
              manual = mkOption {
                default = false;
                example = true;
                description = ''
                  Configuring authelia's secret files via the secrets attribute set
                  is intended to be convenient and help catch cases where values are required
                  to run at all.
                  If a user wants to set these values themselves and bypass the validation they can set this value to true.
                '';
                type = types.bool;
              };

              # required
              jwtSecretFile = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  Path to your JWT secret used during identity verificaton.
                '';
              };

              oidcIssuerPrivateKeyFile = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  Path to your private key file used to encrypt OIDC JWTs.
                '';
              };

              oidcHmacSecretFile = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  Path to your HMAC secret used to sign OIDC JWTs.
                '';
              };

              sessionSecretFile = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  Path to your session secret. Only used when redis is used as session storage.
                '';
              };

              # required
              storageEncryptionKeyFile = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  Path to your storage encryption key.
                '';
              };
            };
          };
        };

        environmentVariables = mkOption {
          type = types.attrsOf types.str;
          description = ''
            Additional environment variables to provide to authelia.
            If you are providing secrets please consider the options under {option}`services.authelia.<instance>.secrets`
            or make sure you use the `_FILE` suffix.
            If you provide the raw secret rather than the location of a secret file that secret will be preserved in the nix store.
            For more details: https://www.authelia.com/configuration/methods/secrets/
          '';
          default = { };
        };

        settings = mkOption {
          description = ''
            Your Authelia config.yml as a Nix attribute set.
            There are several values that are defined and documented in nix such as `default_2fa_method`,
            but additional items can also be included.

            https://github.com/authelia/authelia/blob/master/config.template.yml
          '';
          default = { };
          example = ''
            {
              theme = "light";
              default_2fa_method = "totp";
              log.level = "debug";
              server.disable_healthcheck = true;
            }
          '';
          type = types.submodule {
            freeformType = format.type;
            options = {
              theme = mkOption {
                type = types.enum [
                  "light"
                  "dark"
                  "grey"
                  "auto"
                ];
                default = "light";
                example = "dark";
                description = "The theme to display.";
              };

              default_2fa_method = mkOption {
                type = types.enum [
                  ""
                  "totp"
                  "webauthn"
                  "mobile_push"
                ];
                default = "";
                example = "webauthn";
                description = ''
                  Default 2FA method for new users and fallback for preferred but disabled methods.
                '';
              };

              server = {
                host = mkOption {
                  type = types.str;
                  default = "localhost";
                  example = "0.0.0.0";
                  description = "The address to listen on.";
                };

                port = mkOption {
                  type = types.port;
                  default = 9091;
                  description = "The port to listen on.";
                };
              };

              log = {
                level = mkOption {
                  type = types.enum [
                    "info"
                    "debug"
                    "trace"
                  ];
                  default = "debug";
                  example = "info";
                  description = "Level of verbosity for logs: info, debug, trace.";
                };

                format = mkOption {
                  type = types.enum [
                    "json"
                    "text"
                  ];
                  default = "json";
                  example = "text";
                  description = "Format the logs are written as.";
                };

                file_path = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  example = "/var/log/authelia/authelia.log";
                  description = "File path where the logs will be written. If not set logs are written to stdout.";
                };

                keep_stdout = mkOption {
                  type = types.bool;
                  default = false;
                  example = true;
                  description = "Whether to also log to stdout when a `file_path` is defined.";
                };
              };

              telemetry = {
                metrics = {
                  enabled = mkOption {
                    type = types.bool;
                    default = false;
                    example = true;
                    description = "Enable Metrics.";
                  };

                  address = mkOption {
                    type = types.str;
                    default = "tcp://127.0.0.1:9959";
                    example = "tcp://0.0.0.0:8888";
                    description = "The address to listen on for metrics. This should be on a different port to the main `server.port` value.";
                  };
                };
              };
            };
          };
        };

        settingsFiles = mkOption {
          type = types.listOf types.path;
          default = [ ];
          example = [
            "/etc/authelia/config.yml"
            "/etc/authelia/access-control.yml"
            "/etc/authelia/config/"
          ];
          description = ''
            Here you can provide authelia with configuration files or directories.
            It is possible to give authelia multiple files and use the nix generated configuration
            file set via {option}`services.authelia.<instance>.settings`.
          '';
        };
      };
    };
in
{
  options.services.authelia.instances =
    with lib;
    mkOption {
      default = { };
      type = types.attrsOf (types.submodule autheliaOpts);
      description = ''
        Multi-domain protection currently requires multiple instances of Authelia.
        If you don't require multiple instances of Authelia you can define just the one.

        https://www.authelia.com/roadmap/active/multi-domain-protection/
      '';
      example = ''
        {
          main = {
            enable = true;
            secrets.storageEncryptionKeyFile = "/etc/authelia/storageEncryptionKeyFile";
            secrets.jwtSecretFile = "/etc/authelia/jwtSecretFile";
            settings = {
              theme = "light";
              default_2fa_method = "totp";
              log.level = "debug";
              server.disable_healthcheck = true;
            };
          };
          preprod = {
            enable = false;
            secrets.storageEncryptionKeyFile = "/mnt/pre-prod/authelia/storageEncryptionKeyFile";
            secrets.jwtSecretFile = "/mnt/pre-prod/jwtSecretFile";
            settings = {
              theme = "dark";
              default_2fa_method = "webauthn";
              server.host = "0.0.0.0";
            };
          };
          test.enable = true;
          test.secrets.manual = true;
          test.settings.theme = "grey";
          test.settings.server.disable_healthcheck = true;
          test.settingsFiles = [ "/mnt/test/authelia" "/mnt/test-authelia.conf" ];
          };
        }
      '';
    };

  config =
    let
      mkInstanceServiceConfig =
        instance:
        let
          execCommand = "${instance.package}/bin/authelia";
          configFile = format.generate "config.yml" instance.settings;
          configArg = "--config ${
            builtins.concatStringsSep "," (
              lib.concatLists [
                [ configFile ]
                instance.settingsFiles
              ]
            )
          }";
        in
        {
          description = "Authelia authentication and authorization server";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          environment =
            (lib.filterAttrs (_: v: v != null) {
              AUTHELIA_JWT_SECRET_FILE = instance.secrets.jwtSecretFile;
              AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = instance.secrets.storageEncryptionKeyFile;
              AUTHELIA_SESSION_SECRET_FILE = instance.secrets.sessionSecretFile;
              AUTHELIA_IDENTITY_PROVIDERS_OIDC_ISSUER_PRIVATE_KEY_FILE =
                instance.secrets.oidcIssuerPrivateKeyFile;
              AUTHELIA_IDENTITY_PROVIDERS_OIDC_HMAC_SECRET_FILE = instance.secrets.oidcHmacSecretFile;
            })
            // instance.environmentVariables;

          preStart = "${execCommand} ${configArg} validate-config";
          serviceConfig = {
            User = instance.user;
            Group = instance.group;
            ExecStart = "${execCommand} ${configArg}";
            Restart = "always";
            RestartSec = "5s";
            StateDirectory = "authelia-${instance.name}";
            StateDirectoryMode = "0700";

            # Security options:
            AmbientCapabilities = "";
            CapabilityBoundingSet = "";
            DeviceAllow = "";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;

            PrivateTmp = true;
            PrivateDevices = true;
            PrivateUsers = true;

            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = "read-only";
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "noaccess";
            ProtectSystem = "strict";

            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;

            SystemCallArchitectures = "native";
            SystemCallErrorNumber = "EPERM";
            SystemCallFilter = [
              "@system-service"
              "~@cpu-emulation"
              "~@debug"
              "~@keyring"
              "~@memlock"
              "~@obsolete"
              "~@privileged"
              "~@setuid"
            ];
          };
        };
      mkInstanceUsersConfig = instance: {
        groups."authelia-${instance.name}" = lib.mkIf (instance.group == "authelia-${instance.name}") {
          name = "authelia-${instance.name}";
        };
        users."authelia-${instance.name}" = lib.mkIf (instance.user == "authelia-${instance.name}") {
          name = "authelia-${instance.name}";
          isSystemUser = true;
          group = instance.group;
        };
      };
      instances = lib.attrValues cfg.instances;
    in
    {
      assertions = lib.flatten (
        lib.flip lib.mapAttrsToList cfg.instances (
          name: instance: [
            {
              assertion =
                instance.secrets.manual
                || (instance.secrets.jwtSecretFile != null && instance.secrets.storageEncryptionKeyFile != null);
              message = ''
                Authelia requires a JWT Secret and a Storage Encryption Key to work.
                Either set them like so:
                services.authelia.${name}.secrets.jwtSecretFile = /my/path/to/jwtsecret;
                services.authelia.${name}.secrets.storageEncryptionKeyFile = /my/path/to/encryptionkey;
                Or set services.authelia.${name}.secrets.manual = true and provide them yourself via
                environmentVariables or settingsFiles.
                Do not include raw secrets in nix settings.
              '';
            }
          ]
        )
      );

      systemd.services = lib.mkMerge (
        map (
          instance:
          lib.mkIf instance.enable {
            "authelia-${instance.name}" = mkInstanceServiceConfig instance;
          }
        ) instances
      );
      users = lib.mkMerge (
        map (instance: lib.mkIf instance.enable (mkInstanceUsersConfig instance)) instances
      );
    };
}
