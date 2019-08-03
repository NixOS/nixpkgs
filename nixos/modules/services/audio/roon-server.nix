{ config, lib, pkgs, ... }:

with lib;

let
  name = "roon-server";
  cfg = config.services.roon-server;
in {
  options = {
    services.roon-server = {
      enable = mkEnableOption "Roon Server";
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the server.

          UDP: 9003
          TCP: 9100 - 9200
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.roon-server = {
      after = [ "network.target" ];
      description = "Roon Server";
      wantedBy = [ "multi-user.target" ];

      environment.ROON_DATAROOT = "/var/lib/${name}";

      serviceConfig = {
        ExecStart = "${pkgs.roon-server}/opt/start.sh";
        LimitNOFILE = 8192;
        DynamicUser = true;
        SupplementaryGroups = "audio";
        StateDirectory = name;
      };
    };
    
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPortRanges = [
        { from = 9100; to = 9200; }
      ];
      allowedUDPPorts = [ 9003 ];
    };
  };
}
