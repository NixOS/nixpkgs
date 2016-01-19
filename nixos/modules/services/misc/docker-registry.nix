{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dockerRegistry;

in {
  ###### interface

  options.services.dockerRegistry = {
    enable = mkOption {
      description = "Whether to enable docker registry server.";
      default = false;
      type = types.bool;
    };

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

    extraConfig = mkOption {
      description = ''
        Docker extra registry configuration. See
        <link xlink:href="https://github.com/docker/docker-registry/blob/master/config/config_sample.yml"/>
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

      environment = {
        REGISTRY_HOST = cfg.listenAddress;
        REGISTRY_PORT = toString cfg.port;
        GUNICORN_OPTS = "[--preload]"; # see https://github.com/docker/docker-registry#sqlalchemy
        STORAGE_PATH = cfg.storagePath;
      } // cfg.extraConfig;

      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.docker_registry}/bin/docker-registry";
        User = "docker-registry";
        Group = "docker";
        PermissionsStartOnly = true;
        WorkingDirectory = cfg.storagePath;
      };

      postStart = ''
        until ${pkgs.curl.bin}/bin/curl -s -o /dev/null 'http://${cfg.listenAddress}:${toString cfg.port}/'; do
          sleep 1;
        done
      '';
    };

    users.extraGroups.docker.gid = mkDefault config.ids.gids.docker;
    users.extraUsers.docker-registry = {
      createHome = true;
      home = cfg.storagePath;
      uid = config.ids.uids.docker-registry;
    };
  };
}
