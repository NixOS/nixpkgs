{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dockerRegistry;

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

      environment = {
        REGISTRY_HTTP_ADDR = "${cfg.listenAddress}:${toString cfg.port}";
        REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY = cfg.storagePath;
      } // cfg.extraConfig;

      script = ''
        ${pkgs.docker-distribution}/bin/registry serve \
          ${pkgs.docker-distribution.out}/share/go/src/github.com/docker/distribution/cmd/registry/config-example.yml
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
