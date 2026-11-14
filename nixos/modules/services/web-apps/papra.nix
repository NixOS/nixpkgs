{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.papra;
  defaultUser = "papra";
  defaultGroup = "papra";
in
{
  imports = [
    (lib.mkChangedOptionModule
      [ "services" "papra" "environmentFile" ]
      [ "services" "papra" "environmentFiles" ]
      (
        config:
        let
          value = lib.getAttrFromPath [ "services" "papra" "environmentFile" ] config;
        in
        if value == null then [ ] else [ value ]
      )
    )
  ];

  options = {
    services.papra = {
      enable = lib.mkEnableOption "Papra";

      user = lib.mkOption {
        default = defaultUser;
        type = lib.types.str;
        description = "User under which Papra runs.";
      };

      group = lib.mkOption {
        default = defaultGroup;
        type = lib.types.str;
        description = ''
          If the default user "${defaultUser}" is configured then this is the primary
          group of that user.
        '';
      };

      package = lib.mkPackageOption pkgs "papra" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the firewall for Papra.
        '';
      };

      environment = lib.mkOption {
        type = lib.types.submodule {
          freeformType =
            with lib.types;
            attrsOf (oneOf [
              str
              int
              float
              bool
              path
              package
            ]);

          options = {
            PORT = lib.mkOption {
              type = lib.types.port;
              default = 1221;
              description = ''
                The port on which Papra listens.
                See <https://docs.papra.app/self-hosting/configuration/#port> for more information.
              '';
            };

            DATABASE_URL = lib.mkOption {
              type = lib.types.str;
              default = "file:/var/lib/papra/db.sqlite";
              description = ''
                The URL of the database.
                See <https://docs.papra.app/self-hosting/configuration/#database_url> for more information.

                ::: {.note}
                When specifying a `file:` URL with an absolute path through this option,
                the database's parent directory is automatically added to the systemd
                service's `ReadWritePaths`. Other local database paths, including paths
                specified through `environmentFiles`, may need to be added to `ReadWritePaths` manually.
                :::
              '';
            };

            INGESTION_FOLDER_ROOT_PATH = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/papra/ingestion";
              description = ''
                The root directory in which ingestion folders for each organization are stored.
                The parent directory must already exist if using a custom path.
                See <https://docs.papra.app/self-hosting/configuration/#ingestion_folder_root_path> for more information.
              '';
            };

            DOCUMENT_STORAGE_FILESYSTEM_ROOT = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/papra/local-documents";
              description = ''
                The root directory to store documents in.
                The parent directory must already exist if using a custom path.
                See <https://docs.papra.app/self-hosting/configuration/#document_storage_filesystem_root> for more information.
              '';
            };

            SERVER_SERVE_PUBLIC_DIR = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Whether to serve the public directory.
                See <https://docs.papra.app/self-hosting/configuration/#server_serve_public_dir> for more information.
              '';
            };
          };
        };
        default = { };
        description = ''
          Environment variables to pass to Papra.
          See <https://docs.papra.app/self-hosting/configuration/#configuration-variables> for more information.
        '';
      };

      environmentFiles = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        example = [ "/run/secrets/papra.env" ];
        description = ''
          Files to load environment variables from in addition to [](#opt-services.papra.environment).
          This is useful to avoid putting secrets into the nix store.
          See <https://docs.papra.app/self-hosting/configuration/#configuration-variables> for more information.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.optionalAttrs (cfg.user == defaultUser) {
        "${defaultUser}" = {
          description = "Papra service user";
          isSystemUser = true;
          group = cfg.group;
        };
      };
      groups = lib.optionalAttrs (cfg.group == defaultGroup) {
        "${defaultGroup}" = { };
      };
    };

    systemd.tmpfiles.settings."10-papra" = {
      "${cfg.environment.DOCUMENT_STORAGE_FILESYSTEM_ROOT}".d = {
        mode = "0700";
        inherit (cfg) user group;
      };

      "${cfg.environment.INGESTION_FOLDER_ROOT_PATH}".d = {
        mode = "0770";
        inherit (cfg) user group;
      };
    };

    systemd.services.papra = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStartPre = "${lib.getExe' cfg.package "papra-migrate-up"}";
        ExecStart = "${lib.getExe' cfg.package "papra"}";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "papra";
        StateDirectoryMode = "0700";
        EnvironmentFile = cfg.environmentFiles;
        ReadWritePaths = lib.unique (
          [
            cfg.environment.DOCUMENT_STORAGE_FILESYSTEM_ROOT
            cfg.environment.INGESTION_FOLDER_ROOT_PATH
          ]
          ++ lib.optional (lib.hasPrefix "file:/" cfg.environment.DATABASE_URL) (
            dirOf (lib.removePrefix "file:" cfg.environment.DATABASE_URL)
          )
        );

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        LockPersonality = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0007";
      };
      environment = lib.mapAttrs (
        _: s: if lib.isBool s then lib.boolToString s else toString s
      ) cfg.environment;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.environment.PORT ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ wariuccio ];
  };
}
