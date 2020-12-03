{ config, lib, pkgs, ... }:
let
  cfg = config.services.mullvad-vpn;
in
with lib;
{
  options.services.mullvad-vpn.enable = mkOption {
    type = types.bool;
    default = false;
    description = ''
      This option enables Mullvad VPN daemon.
    '';
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    # mullvad-daemon writes to /etc/iproute2/rt_tables
    networking.iproute2.enable = true;

    systemd.services.mullvad-daemon = {
      description = "Mullvad VPN daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      after = [
        "network-online.target"
        "NetworkManager.service"
        "systemd-resolved.service"
      ];
      path = [
        pkgs.iproute
        # Needed for ping
        "/run/wrappers"
      ];
      serviceConfig = {
        StartLimitBurst = 5;
        StartLimitIntervalSec = 20;
        ExecStart = "${pkgs.mullvad-vpn}/bin/mullvad-daemon -v --disable-stdout-timestamps";
        Restart = "always";
        RestartSec = 1;
      };
    };
  };

  meta.maintainers = [ maintainers.xfix ];
}
