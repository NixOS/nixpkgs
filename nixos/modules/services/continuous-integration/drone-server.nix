{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.drone-server;
in {
  options.services.drone-server = {
    enable = mkEnableOption "Drone server";

    config = mkOption {
      default = { };
      type = with types; attrsOf str;
      description = ''
        Configuration (environment variables) for Drone server.

        Consult https://docs.drone-server.io/installation/reference/ for the full list.
      '';
    };

    user = mkOption {
      default = "drone-server";
      type = types.str;
      description = ''
        User the Drone server should execute under.
      '';
    };

    group = mkOption {
      default = "drone-server";
      type = types.str;
      description = ''
        If the default user "drone-server" is configured then this is the primary group of that user.
      '';
    };

    extraGroups = mkOption {
      default = [ ];
      example = [ "wheel" "docker" ];
      description = ''
        List of extra groups that the "drone-server" user should be a part of.
      '';
    };

    extraDockerOptions = mkOption {
      default = [ "--restart=always" "--detach=true" ];
      example = [ "--restart=unless-stopped" "--detach=true" ];
      type = with types; listOf str;
      description = ''
        Specifies the extra options to pass to Docker.
      '';
    };

    hostName = mkOption {
      example = "drone.example.com";
      type = types.str;
      description = ''
        Specifies the external hostname or IP address of the Drone server.

        If using an IP address, a port can also be specified.
      '';
    };

    image = mkOption {
      default = "drone/drone:1";
      example = "drone/drone:latest";
      type = types.str;
      description = ''
        Specifies the Docker image to use for Drone server server.
      '';
    };

    listenAddress = mkOption {
      default = "0.0.0.0";
      example = "localhost";
      type = types.str;
      description = ''
        Specifies the bind address on which the Drone server container HTTP interface listens.
      '';
    };

    port = mkOption {
      default = 80;
      type = types.port;
      description = ''
        Specifies port number on which the Drone server container HTTP interface listens.
      '';
    };

    provider = mkOption {
      type = types.enum [
        "github"
        "bitbucket-cloud"
        "bitbucket-server"
        "gitlab"
        "gitea"
        "gogs"
      ];
      description = ''
        Specifies the Source Control Management provider for Drone server to integrate with.
      '';
    };

    sslPort = mkOption {
      default = 443;
      type = with types; nullOr port;
      description = ''
        Specifies port number on which the Drone server container HTTPS interface listens.
      '';
    };

    workDir = mkOption {
      default = "/var/lib/drone-server";
      type = types.str;
      description = ''
        Specifies the working directory in which the Drone server container volume resides.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.drone-server.config = {
      DRONE_AGENTS_ENABLED = "true";
      DRONE_SERVER_HOSTNAME = cfg.hostName;
      DRONE_SERVER_PROTO = if cfg.sslPort != null then "https" else "http";
    };

    users.groups = optional (cfg.group == "drone-server") {
      name = "drone-server";
      gid = config.ids.gids.drone-server;
    };

    users.users = optional (cfg.user == "drone-server") {
      name = "drone-server";
      description = "drone-server user";
      createHome = true;
      home = cfg.workDir;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
      uid = config.ids.uids.drone-server;
    };

    virtualisation.docker.enable = mkDefault true;

    docker-containers.drone-server = {
      inherit (cfg) image extraDockerOptions;
      environment = cfg.config;
      ports = [ "${cfg.port}:80" ]
        ++ optional (cfg.sslPort != null) "${cfg.sslPort}:443";
      volumes = [ "${cfg.workDir}:/data" ];
    };
  };
}
