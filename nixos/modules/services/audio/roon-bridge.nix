{ config, lib, pkgs, ... }:

with lib;

let
  name = "roon-bridge";
  cfg = config.services.roon-bridge;
in {
  options = {
    services.roon-bridge = {
      enable = mkEnableOption "Roon Bridge";
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the bridge.

          UDP: 9003
          TCP: 9100 - 9200
        '';
      };
      user = mkOption {
        type = types.str;
        default = "roon-bridge";
        description = ''
          User to run the Roon bridge as.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "roon-bridge";
        description = ''
          Group to run the Roon Bridge as.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.roon-bridge = {
      after = [ "network.target" ];
      description = "Roon Bridge";
      wantedBy = [ "multi-user.target" ];

      environment.ROON_DATAROOT = "/var/lib/${name}";

      serviceConfig = {
        ExecStart = "${pkgs.roon-bridge}/start.sh";
        LimitNOFILE = 8192;
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = name;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPortRanges = [
        { from = 9100; to = 9200; }
      ];
      allowedUDPPorts = [ 9003 ];
    };


    users.groups.${cfg.group} = {};
    users.users.${cfg.user} =
      if cfg.user == "roon-bridge" then {
        isSystemUser = true;
        description = "Roon Bridge user";
        group = cfg.group;
        extraGroups = [ "audio" ];
      }
      else {};
  };
}
