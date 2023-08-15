{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.autobrr;
in
{
  options = {
    services.autobrr = {
      enable = mkEnableOption (lib.mdDoc "Autobrr");

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/autobrr";
        description = lib.mdDoc ''
            The directory where Autobrr will create files.
          '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Autobrr web interface.";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc "Configure nginx as a reverse proxy for Autobrr-web and the Go service.";
      };


      user = mkOption {
        type = types.str;
        default = "autobrr";
        description = lib.mdDoc "User account under which Autobrr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "autobrr";
        description = lib.mdDoc "Group under which Autobrr runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules =[
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.autobrr = {
      description = "Autobrr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = rec {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "autobrr";
        ExecStart = "${pkgs.autobrr}/bin/autobrr --config /var/lib/${StateDirectory}";
        Restart = "on-failure";
      };
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts."localhost" = {
        serverName = "localhost";
        listen = [
          { addr = "0.0.0.0"; port = 7575; }
        ];

        # Compiled NPM package
        locations."/" = {
          root = "${pkgs.autobrr}/autobrr-web";
          index = "index.html";
        };

        # Go service
        locations."/api" = {
          proxyPass = "http://127.0.0.1:7474";
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 7575 ];
    };

    users.users = mkIf (cfg.user == "autobrr") {
      autobrr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.autobrr;
        extraGroups = [ "nginx" ];
      };
    };

    users.groups = mkIf (cfg.group == "autobrr") {
      autobrr.gid = config.ids.gids.autobrr;
    };
  };
}
