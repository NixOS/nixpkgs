{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.tranquil-pds;

  inherit (lib) types mkPackageOption mkOption;

  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.tranquil-pds = {
    enable = lib.mkEnableOption "tranquil-pds AT Protocol personal data server";

    package = mkPackageOption pkgs "tranquil-pds" { };

    user = mkOption {
      type = types.str;
      default = "tranquil-pds";
      description = "User under which tranquil-pds runs";
    };

    group = mkOption {
      type = types.str;
      default = "tranquil-pds";
      description = "Group under which tranquil-pds runs";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/tranquil-pds";
      description = "Working directory for tranquil-pds. Also expected to be used for data (blobs)";
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        File to load environment variables from. Loaded variables override
        values set in {option}`environment`.

        Use it to set values of `JWT_SECRET`, `DPOP_SECRET` and `MASTER_KEY`.

        Generate these with:
        ```
        openssl rand -base64 48
        ```
      '';
    };

    database.createLocally = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Create the postgres database and user on the local host.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          server = {
            host = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = "Host for tranquil-pds to listen on";
            };

            port = mkOption {
              type = types.int;
              default = 3000;
              description = "Port for tranquil-pds to listen on";
            };

            hostname = mkOption {
              type = types.str;
              default = "";
              example = "pds.example.com";
              description = "The public-facing hostname of the PDS";
            };

            max_blob_size = mkOption {
              type = types.int;
              default = 10737418240; # 10 GiB
              description = "Maximum allowed blob size in bytes.";
            };
          };

          frontend = {
            enabled =
              lib.mkEnableOption "serving the frontend from the backend. Disable to serve the frontend manually"
              // {
                default = true;
              };

            dir = mkPackageOption pkgs "tranquil-pds-frontend" { };
          };

          storage = {
            path = mkOption {
              type = types.path;
              default = "${cfg.dataDir}/blobs";
              defaultText = "\${cfg.dataDir}/blobs";
              description = "Directory for storing blobs";
            };
          };
          tranquil_store = {
            data_dir = mkOption {
              type = types.path;
              default = "${cfg.dataDir}/store";
              defaultText = "\${cfg.dataDir}/store";
              description = "Directory for tranquil-store files";
            };
          };
        };
      };

      description = ''
        Configuration options to set for the service. Secrets should be
        specified using {option}`environmentFile`.

        Refer to <https://tangled.org/tranquil.farm/tranquil-pds/blob/main/example.toml>
        for available configuration options.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.database.createLocally {
        services.postgresql = {
          enable = true;
          ensureDatabases = [ cfg.user ];
          ensureUsers = [
            {
              name = cfg.user;
              ensureDBOwnership = true;
            }
          ];
        };

        services.tranquil-pds.settings.database.url =
          lib.mkDefault "postgresql:///${cfg.user}?host=/run/postgresql";

        systemd.services.tranquil-pds = {
          requires = [ "postgresql.service" ];
          after = [ "postgresql.service" ];
        };
      })

      {
        users.users.${cfg.user} = {
          isSystemUser = true;
          inherit (cfg) group;
          home = cfg.dataDir;
        };

        users.groups.${cfg.group} = { };

        systemd.tmpfiles.settings."tranquil-pds" =
          lib.genAttrs
            [
              cfg.dataDir
              cfg.settings.storage.path
              cfg.settings.tranquil_store.data_dir
            ]
            (_: {
              d = {
                mode = "0750";
                inherit (cfg) user group;
              };
            });

        environment.etc = {
          "tranquil-pds/config.toml".source =
            let
              conf = settingsFormat.generate "tranquil-pds.toml" cfg.settings;
            in
            pkgs.runCommandLocal "validated-tranquil-config" { nativeBuildInputs = [ cfg.package ]; } ''
              tranquil-server --config ${conf} validate --ignore-secrets
              ln -s ${conf} $out
            '';
        };

        systemd.services.tranquil-pds = {
          description = "Tranquil PDS - ATProtocol Personal Data Server";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            UMask = "0077";
            ExecStart = lib.getExe cfg.package;
            Restart = "on-failure";
            RestartSec = 5;

            WorkingDirectory = cfg.dataDir;
            StateDirectory = "tranquil-pds";
            ReadWritePaths = [
              cfg.settings.storage.path
            ];

            EnvironmentFile = cfg.environmentFiles;

            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
            ProtectProc = "invisible";
            ProcSubset = "pid";
            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            PrivateDevices = true;
            PrivateUsers = true;
            ProtectHostname = true;
            ProtectClock = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            RemoveIPC = true;
            PrivateMounts = true;
            SystemCallFilter = [
              "@system-service"
              "~@privileged @resources"
            ];
            SystemCallArchitectures = "native";
          };
        };
      }
    ]
  );

  meta.maintainers = with lib.maintainers; [ nelind ];
}
