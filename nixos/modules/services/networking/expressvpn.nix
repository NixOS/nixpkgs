{ config, lib, pkgs, ... }:

with lib;
{
  options.services.expressvpn.enable = mkOption {
    type = types.bool;
    default = false;
    description = lib.mdDoc ''
      Enable the ExpressVPN daemon.
    '';
  };

  config = mkIf config.services.expressvpn.enable {
    boot.kernelModules = [ "tun" ];

    systemd.services.expressvpn = {
      description = "ExpressVPN Daemon";
      serviceConfig = {
        ExecStart = "${pkgs.expressvpn}/bin/expressvpnd";
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
    };
  };

  meta.maintainers = with maintainers; [ yureien ];
}
