{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.zerobyte;
in
{
  meta.maintainers = with lib.maintainers; [ pbek ];

  options.services.zerobyte = {
    enable = lib.mkEnableOption "Zerobyte, backup automation for self-hosters built on top of restic";

    package = lib.mkPackageOption pkgs "zerobyte" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "zerobyte";
      description = "User account under which Zerobyte runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "zerobyte";
      description = "Group under which Zerobyte runs.";
    };

    appSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/zerobyte-app-secret";
      description = ''
        Path to a file containing the application secret (32–256 characters),
        used to encrypt sensitive data in the database. Generate one with
        `openssl rand -hex 32`.

        This should not be a path in the Nix store. The file is passed to the
        service via systemd credentials.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/zerobyte";
      description = ''
        Directory used to store the database, encryption keys, local
        repositories, volume mounts and the restic cache.

        Do not point this to a network share, this will cause permission
        issues and strong performance degradation.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.bool
            lib.types.int
            lib.types.str
          ]
        );
      };
      default = { };
      example = {
        BASE_URL = "https://zerobyte.example.com";
        LOG_LEVEL = "debug";
        GOMAXPROCS = 2;
        TRUST_PROXY = true;
      };
      description = ''
        Zerobyte configuration passed as environment variables. See
        <https://github.com/nicotsx/zerobyte#configuration> for the available
        settings.

        `BASE_URL` is required. It is highly discouraged to expose Zerobyte
        directly to the internet; bind `HOST` to localhost and use a secure
        tunnel or an authenticating reverse proxy instead.

        Do not put secrets here; use
        [](#opt-services.zerobyte.environmentFile) instead.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/zerobyte.env";
      description = ''
        Environment file loaded by systemd, which may be used to pass secrets
        such as `APP_SECRET` to Zerobyte without putting them into the Nix
        store.
      '';
    };

    provisioningFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a JSON file with operator-managed repositories and volumes to
        sync at startup. See
        <https://zerobyte.app/docs/guides/provisioning> for the format.

        This may contain secrets, so it should not be a path in the Nix store.
        The file is passed to the service via systemd credentials.
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        cifs-utils
        davfs2
        fuse3
        nfs-utils
        openssh
        sshfs
        util-linux
      ];
      defaultText = lib.literalExpression "with pkgs; [ cifs-utils davfs2 fuse3 nfs-utils openssh sshfs util-linux ]";
      description = ''
        Extra packages added to the `PATH` of the Zerobyte service. The
        default contains the tools needed to mount NFS, SMB, WebDAV and SFTP
        volumes. Add `shoutrrr` here if you want notifications to be
        delivered.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the Zerobyte web interface.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.zerobyte.settings = {
      NODE_ENV = lib.mkDefault "production";
      HOST = lib.mkDefault "127.0.0.1";
      PORT = lib.mkDefault 4096;
      RESTIC_HOSTNAME = lib.mkDefault config.networking.hostName;
      ZEROBYTE_DATABASE_URL = "${cfg.dataDir}/data/zerobyte.db";
      RESTIC_PASS_FILE = "${cfg.dataDir}/data/restic.pass";
      ZEROBYTE_REPOSITORIES_DIR = "${cfg.dataDir}/repositories";
      ZEROBYTE_VOLUMES_DIR = "${cfg.dataDir}/volumes";
      RESTIC_CACHE_DIR = "${cfg.dataDir}/restic/cache";
      RCLONE_CONFIG_DIR = "${cfg.dataDir}/rclone";
      ENABLE_LOCAL_AGENT = lib.mkDefault true;
    }
    // lib.optionalAttrs (cfg.provisioningFile != null) {
      PROVISIONING_PATH = "%d/provisioning.json";
    }
    // lib.optionalAttrs (cfg.appSecretFile != null) {
      APP_SECRET_FILE = "%d/app-secret";
    };

    assertions = [
      {
        assertion = cfg.settings ? BASE_URL;
        message = "services.zerobyte.settings.BASE_URL must be set.";
      }
      {
        assertion = cfg.appSecretFile != null || cfg.environmentFile != null || cfg.settings ? APP_SECRET;
        message = ''
          services.zerobyte: A secret is required to encrypt sensitive data in
          the database. Set `services.zerobyte.appSecretFile` or provide
          `APP_SECRET` via `services.zerobyte.environmentFile`.
        '';
      }
      {
        assertion = !(cfg.settings ? APP_SECRET);
        message = ''
          services.zerobyte.settings.APP_SECRET would expose the secret in the
          Nix store. Use `services.zerobyte.appSecretFile` or
          `services.zerobyte.environmentFile` instead.
        '';
      }
    ];

    systemd.services.zerobyte = {
      description = "Zerobyte backup automation";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = lib.mapAttrs (
        _: value: if lib.isBool value then lib.boolToString value else toString value
      ) cfg.settings;

      path = [ cfg.package ] ++ cfg.extraPackages;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        StateDirectory = lib.mkIf (lib.hasPrefix "/var/lib/" cfg.dataDir) (
          lib.removePrefix "/var/lib/" cfg.dataDir
        );
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential =
          lib.optional (cfg.appSecretFile != null) "app-secret:${cfg.appSecretFile}"
          ++ lib.optional (cfg.provisioningFile != null) "provisioning.json:${cfg.provisioningFile}";

        # The local agent and the volume mount backends need these to perform
        # NFS, SMB, WebDAV and SFTP mounts.
        AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_SYS_ADMIN" ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = lib.mkDefault false;
        ProtectSystem = lib.mkDefault "full";
        RestartSec = "10s";
        UMask = "0077";
      };
    };

    users.users = lib.mkIf (cfg.user == "zerobyte") {
      zerobyte = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "zerobyte") { zerobyte = { }; };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ (lib.toInt (toString cfg.settings.PORT)) ];
    };
  };
}
