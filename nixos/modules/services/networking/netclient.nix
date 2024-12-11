{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.netclient;
in
{
  meta.maintainers = with lib.maintainers; [ wexder ];

  options.services.netclient = {
    enable = lib.mkEnableOption "Netclient Daemon";
    package = lib.mkPackageOption pkgs "netclient" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.netclient = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      description = "Netclient Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} daemon";
        Restart = "on-failure";
        RestartSec = "15s";
      };
    };
  };
}
