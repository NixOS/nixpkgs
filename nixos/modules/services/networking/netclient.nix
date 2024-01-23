{ config, pkgs, lib, ... }:
let
  cfg = config.services.netclient;
in
{
  meta.maintainers = with lib.maintainers; [ wexder ];

  options.services.netclient = {
    enable = lib.mkEnableOption (lib.mdDoc "Netclient Daemon");
    package = lib.mkPackageOption pkgs "netclient" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.netclient = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "Netclient Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} daemon";
        Restart = "on-failure";
        RestartSec = "15s";
      };

      # required for detection of available firewall, then using node as Ingress/Egress hosts
      # see https://github.com/gravitl/netclient/blob/51f4458db0a5560d102d337a342567cb347399a6/config/config.go#L430-L443
      path = let fw = config.networking.firewall; in lib.optionals fw.enable [ fw.package ];
    };
  };
}
