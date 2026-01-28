{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pterodactyl.wings;

  mainConfig = {
    debug = cfg.debug;
    app_name = cfg.appName;
    uuid = cfg.uuid;
    token_id = if cfg.tokenIdFile != null then "@TOKEN_ID@" else cfg.tokenId;
    token = if cfg.tokenFile != null then "@TOKEN@" else cfg.token;
    api = {
      host = cfg.api.host;
      port = cfg.api.port;
      ssl = {
        enabled = cfg.api.ssl.enable;
        cert = cfg.api.ssl.certFile;
        key = cfg.api.ssl.keyFile;
      };
      upload_limit = cfg.api.uploadLimit;
      trusted_proxies = cfg.api.trustedProxies;
    };
    system = {
      root_directory = cfg.rootDir;
      log_directory = cfg.logDir;
      data = "${cfg.rootDir}/volumes";
      archive_directory = "${cfg.rootDir}/archives";
      backup_directory = "${cfg.rootDir}/backups";
      tmp_directory = cfg.tmpDir;
      username = cfg.user;
      user = {
        uid = config.users.users.${cfg.user}.uid;
        gid = config.users.groups.${cfg.group}.gid;
      };
      sftp = {
        bind_address = cfg.system.sftp.host;
        bind_port = cfg.system.sftp.port;
      };
      docker = {
        tmpfs_size = cfg.docker.tmpfsSize;
        container_pid_limit = cfg.docker.containerPidLimit;
        installer_limits = {
          memory = cfg.docker.installerLimits.memory;
          cpu = cfg.docker.installerLimits.cpu;
        };
      };
      passwd.directory = "${cfg.runDir}/etc";
      machine_id.directory = "${cfg.runDir}/machine-id";
      use_openat2 = false;
    };
    remote = cfg.remote;
    ignore_panel_config_updates = true;
  };

  setupScript = pkgs.writeShellApplication {
    name = "pterodactyl-wings-setup";
    runtimeInputs = with pkgs; [
      coreutils
      replace-secret
    ];
    text = ''
      install -Dm640 -o ${cfg.user} -g ${cfg.group} ${
        (pkgs.formats.yaml { }).generate "config.yml" (lib.recursiveUpdate mainConfig cfg.extraConfig)
      } ${cfg.rootDir}/config.yml

      ${lib.optionalString (cfg.tokenIdFile != null) ''
        replace-secret '@TOKEN_ID@' ${lib.escapeShellArg cfg.tokenIdFile} ${cfg.rootDir}/config.yml
      ''}

      ${lib.optionalString (cfg.tokenFile != null) ''
        replace-secret '@TOKEN@' ${lib.escapeShellArg cfg.tokenFile} ${cfg.rootDir}/config.yml
      ''}
    '';
  };

  cfgService = {
    User = cfg.user;
    Group = cfg.group;
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
  };
in
{
  options.services.pterodactyl.wings = {
    enable = lib.mkEnableOption "Pterodactyl Wings service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pterodactyl.wings;
      defaultText = "pkgs.pterodactyl.wings";
      description = "The Pterodactyl Wings package to use";
    };

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

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to run Wings in debug mode";
    };

    appName = lib.mkOption {
      type = lib.types.str;
      default = "Pterodactyl";
      description = "The name of the daemon";
    };

    uuid = lib.mkOption {
      type = lib.types.str;
      description = "A unique identifier for this node in the panel";
    };

    tokenId = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "An identifier for the token";
    };

    tokenIdFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the token ID";
    };

    token = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The token for communicating with the panel";
    };

    tokenFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the token";
    };

    remote = lib.mkOption {
      type = lib.types.str;
      description = "The URL of the panel to connect to";
    };

    api = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "The interface that Wings should bind to";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "The port that Wings should bind to";
      };

      ssl = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable SSL for the API";
        };

        certFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to the SSL certificate file";
        };

        keyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to the SSL key file";
        };
      };

      uploadLimit = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "The maximum size for files uploaded through the panel in MB";
      };

      trustedProxies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "A list of trusted proxy IP addresses";
      };
    };

    system.sftp = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "The interface that Wings's SFTP should bind to";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 2022;
        description = "The port that Wings's SFTP should bind to";
      };
    };

    docker = {
      tmpfsSize = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "The size of the temporary directory in MB for the container";
      };

      containerPidLimit = lib.mkOption {
        type = lib.types.int;
        default = 512;
        description = "Total number of processes that can be active in a container";
      };

      installerLimits = {
        memory = lib.mkOption {
          type = lib.types.int;
          default = 1024;
          description = "The maximum amount of RAM the installation process can use";
        };

        cpu = lib.mkOption {
          type = lib.types.int;
          default = 100;
          description = "The maximum amount of CPU the installation process can use";
        };
      };
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Extra configuration to be merged with the main configuration";
    };

    extraConfigFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Extra configuration file to be merged with the other configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.uuid != "";
        message = "services.pterodactyl.wings.uuid must be set";
      }
      {
        assertion = cfg.remote != "";
        message = "services.pterodactyl.wings.remote must be set";
      }
      {
        assertion = cfg.tokenId == null || cfg.tokenIdFile == null;
        message = "cannot set both services.pterodactyl.wings.tokenId and services.pterodactyl.wings.tokenIdFile";
      }
      {
        assertion = cfg.tokenId != null || cfg.tokenIdFile != null;
        message = "must set either services.pterodactyl.wings.tokenId or services.pterodactyl.wings.tokenIdFile";
      }
      {
        assertion = cfg.token == null || cfg.tokenFile == null;
        message = "cannot set both services.pterodactyl.wings.token and services.pterodactyl.wings.tokenFile";
      }
      {
        assertion = cfg.token != null || cfg.tokenFile != null;
        message = "must set either services.pterodactyl.wings.token or services.pterodactyl.wings.tokenFile";
      }
    ];

    virtualisation.docker.enable = true;

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.api.port
      cfg.system.sftp.port
    ];

    systemd.tmpfiles.settings."10-pterodactyl-wings" =
      lib.attrsets.genAttrs
        [
          "${cfg.rootDir}/volumes"
          "${cfg.rootDir}/volumes/.sftp"
          "${cfg.rootDir}/archives"
          "${cfg.rootDir}/backups"
        ]
        (n: {
          d = {
            user = cfg.user;
            group = cfg.group;
            mode = "0755";
          };
        })
      // {
        "${cfg.rootDir}".d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0750";
        };
        "${cfg.rootDir}/wings.db".z = {
          user = cfg.user;
          group = cfg.group;
          mode = "0644";
        };
        "${cfg.rootDir}/states.json".z = {
          user = cfg.user;
          group = cfg.group;
          mode = "0644";
        };
        "${cfg.runDir}".d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0755";
        };
        "${cfg.logDir}".d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0755";
        };
        "${cfg.tmpDir}".d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0755";
        };
      };

    systemd.services.pterodactyl-wings-setup = {
      description = "Pterodactyl Wings setup";
      before = [ "pterodactyl-wings.service" ];
      requiredBy = [ "pterodactyl-wings.service" ];

      serviceConfig = cfgService // {
        Type = "oneshot";
        ExecStart = lib.getExe setupScript;
        RemainAfterExit = true;
      };
    };

    systemd.services.pterodactyl-wings = {
      description = "Pterodactyl Wings service";
      after = [
        "network-online.target"
        "docker.service"
        "pterodactyl-wings-setup.service"
      ];
      wants = [ "network-online.target" ];
      requires = [
        "docker.service"
        "pterodactyl-wings-setup.service"
      ];
      partOf = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = cfgService // {
        ExecStart = "${cfg.package}/bin/wings --config ${cfg.rootDir}/config.yml";
        Restart = "on-failure";
        AmbientCapabilities = "CAP_CHOWN";
        EnvironmentFile = lib.optional (cfg.extraConfigFile != null) cfg.extraConfigFile;
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
