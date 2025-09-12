{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ivpn;
in
{
  options.services.ivpn = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        This option enables iVPN daemon.
        This sets {option}`networking.firewall.checkReversePath` to "loose", which might be undesirable for security.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    environment.systemPackages = with pkgs; [
      ivpn
      ivpn-service
    ];

    # iVPN writes to /etc/iproute2/rt_tables
    networking.iproute2.enable = true;
    networking.firewall.checkReversePath = "loose";

    systemd.services.ivpn-service = {
      description = "iVPN daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network.target"
        "network-online.target"
      ];
      after = [
        "network-online.target"
        "NetworkManager.service"
        "systemd-resolved.service"
      ];
      path = [
        # Needed for mount
        "/run/wrappers"
      ];
      startLimitBurst = 5;
      startLimitIntervalSec = 20;
      serviceConfig = {
        ExecStart = "${pkgs.ivpn-service}/bin/ivpn-service --logging";
        Restart = "always";
        RestartSec = 1;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ];
}
