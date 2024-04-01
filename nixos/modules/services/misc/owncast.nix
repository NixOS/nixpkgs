{ lib, pkgs, config, ... }:
with lib;
let cfg = config.services.owncast;
in {

  options.services.owncast = {

    enable = mkEnableOption "owncast";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/owncast";
      description = lib.mdDoc ''
        The directory where owncast stores its data files. If left as the default value this directory will automatically be created before the owncast server starts, otherwise the sysadmin is responsible for ensuring the directory exists with appropriate ownership and permissions.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open the appropriate ports in the firewall for owncast.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "owncast";
      description = lib.mdDoc "User account under which owncast runs.";
    };

    group = mkOption {
      type = types.str;
      default = "owncast";
      description = lib.mdDoc "Group under which owncast runs.";
    };

    listen = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = lib.mdDoc "The IP address to bind the owncast web server to.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        TCP port where owncast web-gui listens.
      '';
    };

    rtmp-port = mkOption {
      type = types.port;
      default = 1935;
      description = lib.mdDoc ''
        TCP port where owncast rtmp service listens.
      '';
    };

  };

  config = mkIf cfg.enable {

    systemd.services.owncast = {
      description = "A self-hosted live video and web chat server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = mkMerge [
        {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${pkgs.owncast}/bin/owncast -webserverport ${toString cfg.port} -rtmpport ${toString cfg.rtmp-port} -webserverip ${cfg.listen}";
          Restart = "on-failure";
        }
        (mkIf (cfg.dataDir == "/var/lib/owncast") {
          StateDirectory = "owncast";
        })
      ];
    };

    users.users = mkIf (cfg.user == "owncast") {
      owncast = {
        isSystemUser = true;
        group = cfg.group;
        description = "owncast system user";
      };
    };

    users.groups = mkIf (cfg.group == "owncast") { owncast = { }; };

    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.rtmp-port ] ++ optional (cfg.listen != "127.0.0.1") cfg.port; };

  };
  meta = { maintainers = with lib.maintainers; [ MayNiklas ]; };
}
