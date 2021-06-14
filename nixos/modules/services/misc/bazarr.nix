{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.bazarr;
in
{
  options = {
    services.bazarr = {
      enable = mkEnableOption "bazarr, a subtitle manager for Sonarr and Radarr";

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the bazarr web interface.";
      };

      listenPort = mkOption {
        type = types.port;
        default = 6767;
        description = "Port on which the bazarr web interface should listen";
      };

      user = mkOption {
        type = types.str;
        default = "bazarr";
        description = "User account under which bazarr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "bazarr";
        description = "Group under which bazarr runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.bazarr = {
      description = "bazarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = rec {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "bazarr";
        SyslogIdentifier = "bazarr";
        ExecStart = pkgs.writeShellScript "start-bazarr" ''
          ${pkgs.bazarr}/bin/bazarr \
            --config '/var/lib/${StateDirectory}' \
            --port ${toString cfg.listenPort} \
            --no-update True
        '';
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listenPort ];
    };

    users.users = mkIf (cfg.user == "bazarr") {
      bazarr = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${config.systemd.services.bazarr.serviceConfig.StateDirectory}";
      };
    };

    users.groups = mkIf (cfg.group == "bazarr") {
      bazarr = {};
    };
  };
}
