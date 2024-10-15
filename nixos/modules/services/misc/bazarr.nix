{ config, pkgs, lib, ... }:
let
  cfg = config.services.bazarr;
in
{
  options = {
    services.bazarr = {
      enable = lib.mkEnableOption "bazarr, a subtitle manager for Sonarr and Radarr";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the bazarr web interface.";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 6767;
        description = "Port on which the bazarr web interface should listen";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "bazarr";
        description = "User account under which bazarr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "bazarr";
        description = "Group under which bazarr runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
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

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listenPort ];
    };

    users.users = lib.mkIf (cfg.user == "bazarr") {
      bazarr = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${config.systemd.services.bazarr.serviceConfig.StateDirectory}";
      };
    };

    users.groups = lib.mkIf (cfg.group == "bazarr") {
      bazarr = {};
    };
  };
}
