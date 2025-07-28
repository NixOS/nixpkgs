{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dockerRegistry;

  blobCache = if cfg.enableRedisCache then "redis" else "inmemory";

  registryConfig = {
    version = "0.1";
    log.fields.service = "registry";
    storage = {
      cache.blobdescriptor = blobCache;
      delete.enabled = cfg.enableDelete;
    }
    // (lib.optionalAttrs (cfg.storagePath != null) { filesystem.rootdirectory = cfg.storagePath; });
    http = {
      addr = "${cfg.listenAddress}:${builtins.toString cfg.port}";
      headers.X-Content-Type-Options = [ "nosniff" ];
    };
    health.storagedriver = {
      enabled = true;
      interval = "10s";
      threshold = 3;
    };
  };

  registryConfig.redis = lib.mkIf cfg.enableRedisCache {
    addr = "${cfg.redisUrl}";
    password = "${cfg.redisPassword}";
    db = 0;
    dialtimeout = "10ms";
    readtimeout = "10ms";
    writetimeout = "10ms";
    pool = {
      maxidle = 16;
      maxactive = 64;
      idletimeout = "300s";
    };
  };

  configFile = cfg.configFile;
in
{
  options.services.dockerRegistry = {
    enable = lib.mkEnableOption "Docker Registry";

    package = lib.mkPackageOption pkgs "docker-distribution" {
      example = "gitlab-container-registry";
    };

    listenAddress = lib.mkOption {
      description = "Docker registry host or ip to bind to.";
      default = "127.0.0.1";
      type = lib.types.str;
    };

    port = lib.mkOption {
      description = "Docker registry port to bind to.";
      default = 5000;
      type = lib.types.port;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Opens the port used by the firewall.";
    };

    storagePath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = "/var/lib/docker-registry";
      description = ''
        Docker registry storage path for the filesystem storage backend. Set to
        null to configure another backend via extraConfig.
      '';
    };

    enableDelete = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable delete for manifests and blobs.";
    };

    enableRedisCache = lib.mkEnableOption "redis as blob cache";

    redisUrl = lib.mkOption {
      type = lib.types.str;
      default = "localhost:6379";
      description = "Set redis host and port.";
    };

    redisPassword = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Set redis password.";
    };

    extraConfig = lib.mkOption {
      description = ''
        Docker extra registry configuration.
      '';
      example = lib.literalExpression ''
        {
          log.level = "debug";
        }
      '';
      default = { };
      type = lib.types.attrs;
    };

    configFile = lib.mkOption {
      default = pkgs.writeText "docker-registry-config.yml" (
        builtins.toJSON (lib.recursiveUpdate registryConfig cfg.extraConfig)
      );
      defaultText = lib.literalExpression ''pkgs.writeText "docker-registry-config.yml" "# my custom docker-registry-config.yml ..."'';
      description = ''
        Path to CNCF distribution config file.

        Setting this option will override any configuration applied by the extraConfig option.
      '';
      type = lib.types.path;
    };

    enableGarbageCollect = lib.mkEnableOption "garbage collect";

    garbageCollectDates = lib.mkOption {
      default = "daily";
      type = lib.types.str;
      description = ''
        Specification (in the format described by
        {manpage}`systemd.time(7)`) of the time at
        which the garbage collect will occur.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.docker-registry = {
      description = "Docker Container Registry";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      script = ''
        ${cfg.package}/bin/registry serve ${configFile}
      '';

      serviceConfig = {
        User = "docker-registry";
        WorkingDirectory = cfg.storagePath;
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) "cap_net_bind_service";
      };
    };

    systemd.services.docker-registry-garbage-collect = {
      description = "Run Garbage Collection for docker registry";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig.Type = "oneshot";

      script = ''
        ${cfg.package}/bin/registry garbage-collect ${configFile}
        /run/current-system/systemd/bin/systemctl restart docker-registry.service
      '';

      startAt = lib.optional cfg.enableGarbageCollect cfg.garbageCollectDates;
    };

    users.users.docker-registry =
      (lib.optionalAttrs (cfg.storagePath != null) {
        createHome = true;
        home = cfg.storagePath;
      })
      // {
        group = "docker-registry";
        isSystemUser = true;
      };
    users.groups.docker-registry = { };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
