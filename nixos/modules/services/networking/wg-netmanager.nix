{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wg-netmanager;
in
{

  options = {
    services.wg-netmanager = {
      enable = mkEnableOption (lib.mdDoc "Wireguard network manager");
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    # NOTE: wg-netmanager runs as root
    systemd.services.wg-netmanager = {
      description = "Wireguard network manager";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [ wireguard-tools iproute2 wireguard-go ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.wg-netmanager}/bin/wg_netmanager";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

        ReadWritePaths = [
          "/tmp"  # wg-netmanager creates files in /tmp before deleting them after use
        ];
      };
      unitConfig =  {
        ConditionPathExists = ["/etc/wg_netmanager/network.yaml" "/etc/wg_netmanager/peer.yaml"];
      };
    };
  };

  meta.maintainers = with maintainers; [ gin66 ];
}
