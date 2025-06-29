{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.expressvpn-service.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable the ExpressVPN daemon service.
    '';
  };

  config = lib.mkIf config.services.expressvpn-service.enable {
    boot.kernelModules = [ "tun" ];

    systemd.services.expressvpn-service = {
      description = "ExpressVPN Daemon Service";
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

    # These groups are required by expressvpn-daemon
    users.groups.expressvpn = { };
    users.groups.expressvpnhnsd = { };
  };
}
