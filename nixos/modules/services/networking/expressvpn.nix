{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.expressvpn.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable the ExpressVPN daemon.
    '';
  };

  config = lib.mkIf config.services.expressvpn.enable {
    boot.kernelModules = [ "tun" ];

    systemd.services.expressvpn = {
      description = "ExpressVPN Daemon";
      serviceConfig = {
        ExecStart = "${pkgs.expressvpn}/bin/expressvpn-daemon";
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
    };

    # Required groups for ExpressVPN
    users.groups.expressvpn = { };
    users.groups.expressvpnhnsd = { };
  };

  meta.maintainers = with lib.maintainers; [ yureien ];
}
