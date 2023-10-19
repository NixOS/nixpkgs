{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dockerRegistry;

  blobCache = if cfg.enableRedisCache
    then "redis"
    else "inmemory";

  registryConfig = {
    version =  "0.1";
    log.fields.service = "registry";
    storage = {
      cache.blobdescriptor = blobCache;
      delete.enabled = cfg.enableDelete;
    } // (optionalAttrs (cfg.storagePath != null) { filesystem.rootdirectory = cfg.storagePath; });
    http = {
      addr = "${cfg.listenAddress}:${builtins.toString cfg.port}";
      headers.X-Content-Type-Options = ["nosniff"];
    };
    health.storagedriver = {
      enabled = true;
      interval = "10s";
      threshold = 3;
    };
  };

  registryConfig.redis = mkIf cfg.enableRedisCache {
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

  configFile = pkgs.writeText "docker-registry-config.yml" (builtins.toJSON (recursiveUpdate registryConfig cfg.extraConfig));

in {
  options.services.dockerRegistry = {
    enable = mkEnableOption (lib.mdDoc "Docker Registry");

    package = mkOption {
      type = types.package;
      description = mdDoc "Which Docker registry package to use.";
      default = pkgs.docker-distribution;
      defaultText = literalExpression "pkgs.docker-distribution";
      example = literalExpression "pkgs.gitlab-container-registry";
    };

    listenAddress = mkOption {
      description = lib.mdDoc "Docker registry host or ip to bind to.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = lib.mdDoc "Docker registry port to bind to.";
      default = 5000;
      type = types.port;
    };

    storagePath = mkOption {
      type = types.nullOr types.path;
      default = "/var/lib/docker-registry";
      description = lib.mdDoc ''
        Docker registry storage path for the filesystem storage backend. Set to
        null to configure another backend via extraConfig.
      '';
    };

    enableDelete = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable delete for manifests and blobs.";
    };

    enableRedisCache = mkEnableOption (lib.mdDoc "redis as blob cache");

    redisUrl = mkOption {
      type = types.str;
      default = "localhost:6379";
      description = lib.mdDoc "Set redis host and port.";
    };

    redisPassword = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc "Set redis password.";
    };

    extraConfig = mkOption {
      description = lib.mdDoc ''
        Docker extra registry configuration via environment variables.
      '';
      default = {};
      type = types.attrs;
    };

    enableGarbageCollect = mkEnableOption (lib.mdDoc "garbage collect");

    garbageCollectDates = mkOption {
      default = "daily";
      type = types.str;
      description = lib.mdDoc ''
        Specification (in the format described by
        {manpage}`systemd.time(7)`) of the time at
        which the garbage collect will occur.
      '';
    };
  };

  config = mkIf cfg.enable {
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
        AmbientCapabilities = mkIf (cfg.port < 1024) "cap_net_bind_service";
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

      startAt = optional cfg.enableGarbageCollect cfg.garbageCollectDates;
    };

    users.users.docker-registry =
      (optionalAttrs (cfg.storagePath != null) {
        createHome = true;
        home = cfg.storagePath;
      }) // {
        group = "docker-registry";
        isSystemUser = true;
      };
    users.groups.docker-registry = {};
  };
}
