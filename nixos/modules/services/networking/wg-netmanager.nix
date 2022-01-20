{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wg-netmanager;
in
{

  options = {
    services.wg-netmanager = {
      enable = mkEnableOption "Wireguard network manager";
      package = mkOption {
        type = types.package;
        default = pkgs.wg-netmanager;
        defaultText = literalExpression "pkgs.wg-netmanager";
        description = ''
          wg-netmanager derivation to use.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {

    systemd.services.wg-netmanager = {
      description = "Wireguard network manager";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/wg_netmanager -c ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

        ReadWritePaths = [
          "/tmp"  # wg-netmanager creates files in /tmp before deleting them after use
        ];
      unitConfig =  {
        ConditionPathExists = ["/etc/wg_netmanager/network.yaml" "/etc/wg_netmanager/peer.yaml"];
      };
    };
   };
  };

  meta.maintainers = with maintainers; [ gin66 ];
}
