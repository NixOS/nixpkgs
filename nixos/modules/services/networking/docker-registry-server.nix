{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nodeDockerRegistry;

in {
  options.services.nodeDockerRegistry = {
    enable = mkEnableOption "docker registry service";

    port = mkOption {
      description = "Docker registry listening port.";
      default = 8080;
      type = types.int;
    };

    users = mkOption {
      description = "Docker registry list of users.";
      default = [];
      options = [{
        user = mkOption {
          description = "Docker registry user username.";
          type = types.str;
        };

        pass = mkOption {
          description = "Docker registry user password.";
          type = types.str;
        };
      }];
      type = types.listOf types.optionSet;
    };

    onTag = mkOption {
      description = "Docker registry hook triggered when an image is tagged.";
      default = "";
      type = types.str;
    };

    onImage = mkOption {
      description = "Docker registry hook triggered when an image metadata is uploaded.";
      default = "";
      type = types.str;
    };

    onLayer = mkOption {
      description = "Docker registry hook triggered when an when an image layer is uploaded.";
      default = "";
      type = types.str;
    };

    onVerify = mkOption {
      description = "Docker registry hook triggered when an image layer+metadata has been verified.";
      default = "";
      type = types.str;
    };

    onIndex = mkOption {
      description = "Docker registry hook triggered when an when an image file system data has been indexed.";
      default = "";
      type = types.str;
    };

    dataDir = mkOption {
      description = "Docker registry data directory";
      default = "/var/lib/docker-registry";
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.docker-registry-server = {
      description = "Docker Registry Service.";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      script = ''
        ${pkgs.nodePackages.docker-registry-server}/bin/docker-registry-server \
          --dir ${cfg.dataDir} \
          --port ${toString cfg.port} \
          ${concatMapStringsSep " " (u: "--user ${u.user}:${u.pass}") cfg.users} \
          ${optionalString (cfg.onTag != "") "--on-tag '${cfg.onTag}'"} \
          ${optionalString (cfg.onImage != "") "--on-image '${cfg.onImage}'"} \
          ${optionalString (cfg.onVerify != "") "--on-verify '${cfg.onVerify}'"} \
          ${optionalString (cfg.onIndex != "") "--on-index '${cfg.onIndex}'"}
      '';

      serviceConfig.User = "docker-registry";
    };

    users.extraUsers.docker-registry = {
      uid = config.ids.uids.docker-registry;
      description = "Docker registry user";
      createHome = true;
      home = cfg.dataDir;
    };
  };
}
