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
      filesystem.rootdirectory = cfg.storagePath;
      delete.enabled = cfg.enableDelete;
    };
    http = {
      addr = ":${builtins.toString cfg.port}";
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

in {
  options.services.dockerRegistry = {
    enable = mkEnableOption "Docker Registry";

    listenAddress = mkOption {
      description = "Docker registry host or ip to bind to.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Docker registry port to bind to.";
      default = 5000;
      type = types.int;
    };

    storagePath = mkOption {
      type = types.path;
      default = "/var/lib/docker-registry";
      description = "Docker registry storage path.";
    };

    enableDelete = mkOption {
      type = types.bool;
      default = false;
      description = "Enable delete for manifests and blobs.";
    };

    enableRedisCache = mkOption {
      type = types.bool;
      default = false;
      description = "Enable redis as blob cache instade of inmemory.";
    };

    redisUrl = mkOption {
      type = types.str;
      default = "localhost:6379";
      description = "Set redis host and port.";
    };

    redisPassword = mkOption {
      type = types.str;
      default = "";
      description = "Set redis password.";
    };

    extraConfig = mkOption {
      description = ''
        Docker extra registry configuration via environment variables.
      '';
      default = {};
      type = types.attrsOf types.str;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.docker-registry = {
      description = "Docker Container Registry";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      script = let
        configFile = pkgs.writeText "docker-registry-config.yml" (builtins.toJSON (registryConfig // cfg.extraConfig));
      in ''
        ${pkgs.docker-distribution}/bin/registry serve ${configFile}
      '';

      serviceConfig = {
        User = "docker-registry";
        WorkingDirectory = cfg.storagePath;
      };
    };

    users.extraUsers.docker-registry = {
      createHome = true;
      home = cfg.storagePath;
    };
  };
}
