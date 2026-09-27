{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pterodactyl.wings;
  yaml = pkgs.formats.yaml { };
in
{
  options.services.pterodactyl.wings = {
    enable = lib.mkEnableOption "Pterodactyl Wings service";

    package = lib.mkPackageOption pkgs "pterodactyl-wings" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "pterodactyl-wings";
      description = "User to run Wings as";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "pterodactyl-wings";
      description = "Group to run Wings as";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the Wings API and SFTP ports in the firewall";
    };

    containerRuntime = lib.mkOption {
      type = lib.types.enum [ "docker" ];
      default = "docker";
      description = "The container runtime to use for Wings";
    };

    rootDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/pterodactyl-wings";
      description = "The root directory where all of Wings's data is stored";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/log/pterodactyl-wings";
      description = "Directory where logs for Wings and server installations are stored";
    };

    tmpDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/cache/pterodactyl-wings";
      description = "Directory where temporary files for server installations are stored";
    };

    runDir = lib.mkOption {
      type = lib.types.path;
      default = "/run/pterodactyl-wings";
      description = "Directory where runtime files are stored";
    };

    secrets = {
      tokenIdFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to token ID secret file";
      };

      tokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to token secret file";
      };
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = yaml.type;
      };
      default = { };
      description = "Wings configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings ? uuid && cfg.settings.uuid != "";
        message = "services.pterodactyl.wings.settings.uuid must be set";
      }
      {
        assertion = cfg.settings ? remote && cfg.settings.remote != "";
        message = "services.pterodactyl.wings.settings.remote must be set";
      }
      {
        assertion =
          (cfg.secrets.tokenIdFile != null) || (cfg.settings ? token_id && cfg.settings.token_id != "");
        message = "must set either services.pterodactyl.wings.secrets.tokenIdFile or services.pterodactyl.wings.settings.token_id";
      }
      {
        assertion = (cfg.secrets.tokenFile != null) || (cfg.settings ? token && cfg.settings.token != "");
        message = "must set either services.pterodactyl.wings.secrets.tokenFile or services.pterodactyl.wings.settings.token";
      }
    ];

    services.pterodactyl.wings.settings = {
      token_id = lib.mkIf (cfg.secrets.tokenIdFile != null) (
        lib.mkDefault "file://\${CREDENTIALS_DIRECTORY}/token_id"
      );
      token = lib.mkIf (cfg.secrets.tokenFile != null) (
        lib.mkDefault "file://\${CREDENTIALS_DIRECTORY}/token"
      );

      api = {
        host = lib.mkDefault "0.0.0.0";
        port = lib.mkDefault 8080;
      };

      system = {
        root_directory = lib.mkDefault cfg.rootDir;
        log_directory = lib.mkDefault cfg.logDir;
        data = lib.mkDefault "${cfg.rootDir}/volumes";
        archive_directory = lib.mkDefault "${cfg.rootDir}/archives";
        backup_directory = lib.mkDefault "${cfg.rootDir}/backups";
        tmp_directory = lib.mkDefault cfg.tmpDir;
        username = lib.mkDefault cfg.user;
        user = {
          uid = lib.mkDefault config.users.users.${cfg.user}.uid;
          gid = lib.mkDefault config.users.groups.${cfg.group}.gid;
        };
        sftp = {
          bind_address = lib.mkDefault "0.0.0.0";
          bind_port = lib.mkDefault 2022;
        };
        passwd.directory = lib.mkDefault "${cfg.runDir}/etc";
        machine_id.directory = lib.mkDefault "${cfg.runDir}/machine-id";
      };

      ignore_panel_config_updates = lib.mkDefault true;
    };

    virtualisation.docker.enable = lib.mkIf (cfg.containerRuntime == "docker") true;

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.settings.api.port
      cfg.settings.system.sftp.bind_port
    ];

    systemd.services.pterodactyl-wings = {
      description = "Pterodactyl Wings service";
      after = [
        "network-online.target"
        "docker.service"
      ];
      wants = [ "network-online.target" ];
      requires = [ "docker.service" ];
      partOf = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        StateDirectory = lib.removePrefix "/var/lib/" cfg.rootDir;
        LogsDirectory = lib.removePrefix "/var/log/" cfg.logDir;
        CacheDirectory = lib.removePrefix "/var/cache/" cfg.tmpDir;
        RuntimeDirectory = lib.removePrefix "/run/" cfg.runDir;
        ReadWritePaths = [
          cfg.rootDir
          cfg.logDir
          cfg.tmpDir
          cfg.runDir
        ];

        ExecStart = "${lib.getExe cfg.package} --config ${yaml.generate "config.yml" cfg.settings}";
        Restart = "on-failure";
        AmbientCapabilities = "CAP_CHOWN";
        LoadCredential = lib.flatten [
          (lib.optional (cfg.secrets.tokenIdFile != null) "token_id:${cfg.secrets.tokenIdFile}")
          (lib.optional (cfg.secrets.tokenFile != null) "token:${cfg.secrets.tokenFile}")
        ];
      };
    };

    users.users = lib.mkIf (cfg.user == "pterodactyl-wings") {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.rootDir;
        extraGroups = [ "docker" ];
      };
    };

    users.groups = lib.mkIf (cfg.group == "pterodactyl-wings") {
      ${cfg.group} = { };
    };
  };
}
