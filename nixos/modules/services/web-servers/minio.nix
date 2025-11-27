{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.minio;
in
{

  imports = [
    (mkRemovedOptionModule [
      "services"
      "minio"
      "configDir"
    ] "The `--config-dir` argument is deprecated in minio. Use `certificatesDir` and `settings`.")

    (mkRemovedOptionModule [
      "services"
      "minio"
      "accessKey"
    ] "Use `MINIO_ROOT_USER` in `environmentFile` or instead.")

    (mkRemovedOptionModule [
      "services"
      "minio"
      "secretKey"
    ] "Use `MINIO_ROOT_PASSWORD` in `environmentFile` or instead.")

    (mkRenamedOptionModule
      [ "services" "minio" "rootCredentialsFile" ]
      [ "services" "minio" "environmentFile" ]
    )

  ];

  meta.maintainers = with maintainers; [
    bachp
    ryan4yin
  ];

  options.services.minio = {
    enable = mkEnableOption "Minio Object Storage";

    listenAddress = mkOption {
      default = ":9000";
      type = types.str;
      description = "IP address and port of the server.";
    };

    consoleAddress = mkOption {
      default = ":9001";
      type = types.str;
      description = "IP address and port of the web UI (console).";
    };

    dataDir = mkOption {
      default = [ "/var/lib/minio/data" ];
      type = types.listOf (types.either types.path types.str);
      description = "The list of data directories or nodes for storing the objects. Use one path for regular operation and the minimum of 4 endpoints for Erasure Code mode.";
    };

    certificatesDir = mkOption {
      default = "/var/lib/minio/certs";
      type = types.path;
      description = "The directory where TLS certificates are stored.";
    };

    region = mkOption {
      default = "us-east-1";
      type = types.str;
      description = ''
        The physical location of the server. By default it is set to us-east-1, which is same as AWS S3's and Minio's default region.
      '';
    };

    browser = mkOption {
      default = true;
      type = types.bool;
      description = "Enable or disable access to web UI.";
    };

    package = mkPackageOption pkgs "minio" { };

    extraEnvironment = lib.mkOption {
      description = ''
        Environment variables to pass to Minio. This is how most settings
        can be configured.

        See https://github.com/minio/minio/blob/master/docs/config/README.md
      '';
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        MINIO_SITE_REGION = "us-west-0";
        MINIO_SITE_NAME = "sfo-rack-1";
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        An optional path to an environment file that will be used in the web and workers
        services. This is useful for loading secrets like `MINIO_ROOT_PASSWORD`.
      '';
      example = "/etc/nixos/minio-root-credentials";
    };
  };

  config = mkIf cfg.enable {

    systemd = lib.mkMerge [
      {
        tmpfiles.rules = [
          "d '${cfg.certificatesDir}' - minio minio - -"
        ]
        ++ (map (x: "d '" + x + "' - minio minio - - ") (builtins.filter lib.types.path.check cfg.dataDir));

        services.minio = {
          description = "Minio Object Storage";
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/minio server --json --address ${cfg.listenAddress} --console-address ${cfg.consoleAddress} --certs-dir=${cfg.certificatesDir} ${toString cfg.dataDir}";
            Type = "simple";
            User = "minio";
            Group = "minio";
            LimitNOFILE = 65536;
            EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];

            # hardening
            DevicePolicy = "closed";
            CapabilityBoundingSet = "";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
              "AF_UNIX"
            ];
            DeviceAllow = "";
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateMounts = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            MemoryDenyWriteExecute = true;
            LockPersonality = true;
            RemoveIPC = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            ProtectProc = "invisible";
            ProtectHostname = true;
            UMask = "0077";
            # minio opens /proc/mounts on startup
            ProcSubset = "all";
          };
          environment = {
            MINIO_REGION = "${cfg.region}";
            MINIO_BROWSER = "${if cfg.browser then "on" else "off"}";
          }
          // cfg.extraEnvironment;
        };
      }

      (lib.mkIf (cfg.environmentFile != null) {
        # The service will fail if the credentials file is missing
        services.minio.unitConfig.ConditionPathExists = cfg.environmentFile;

        # The service will not restart if the credentials file has
        # been changed. This can cause stale root credentials.
        paths.minio-root-credentials = {
          wantedBy = [ "multi-user.target" ];

          pathConfig = {
            PathChanged = [ cfg.environmentFile ];
            Unit = "minio-restart.service";
          };
        };

        services.minio-restart = {
          description = "Restart MinIO if environment file changes";

          script = ''
            systemctl restart minio.service
          '';

          serviceConfig = {
            Type = "oneshot";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      })
    ];

    users.users.minio = {
      group = "minio";
      uid = config.ids.uids.minio;
    };

    users.groups.minio.gid = config.ids.uids.minio;
  };
}
