{ lib, pkgs, config, ... }:
let cfg = config.services.owncast;
in {

  options.services.owncast = {

    enable = lib.mkEnableOption "owncast, a video live streaming solution";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/owncast";
      description = ''
        The directory where owncast stores its data files. If left as the default value this directory will automatically be created before the owncast server starts, otherwise the sysadmin is responsible for ensuring the directory exists with appropriate ownership and permissions.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the appropriate ports in the firewall for owncast.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "owncast";
      description = "User account under which owncast runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "owncast";
      description = "Group under which owncast runs.";
    };

    listen = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The IP address to bind the owncast web server to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''
        TCP port where owncast web-gui listens.
      '';
    };

    rtmp-port = lib.mkOption {
      type = lib.types.port;
      default = 1935;
      description = ''
        TCP port where owncast rtmp service listens.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.owncast = {
      description = "A self-hosted live video and web chat server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = lib.mkMerge [
        {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${pkgs.owncast}/bin/owncast -webserverport ${toString cfg.port} -rtmpport ${toString cfg.rtmp-port} -webserverip ${cfg.listen}";
          Restart = "on-failure";
        }
        (lib.mkIf (cfg.dataDir == "/var/lib/owncast") {
          StateDirectory = "owncast";
        })
      ];
    };

    users.users = lib.mkIf (cfg.user == "owncast") {
      owncast = {
        isSystemUser = true;
        group = cfg.group;
        description = "owncast system user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "owncast") { owncast = { }; };

    networking.firewall =
      lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.rtmp-port ] ++ lib.optional (cfg.listen != "127.0.0.1") cfg.port; };

  };
  meta = { maintainers = with lib.maintainers; [ MayNiklas ]; };
}
