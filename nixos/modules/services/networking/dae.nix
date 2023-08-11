{ config, pkgs, lib, ... }:
let
  cfg = config.services.dae;
in
{
  meta.maintainers = with lib.maintainers; [ pokon548 ];

  options = {
    services.dae = {
      enable = lib.options.mkEnableOption (lib.mdDoc "the dae service");
      package = lib.mkPackageOptionMD pkgs "dae" { };
    };
  };

  config = lib.mkIf config.services.dae.enable {
    networking.firewall.allowedTCPPorts = [ 12345 ];
    networking.firewall.allowedUDPPorts = [ 12345 ];

    systemd.services.dae = {
      unitConfig = {
        Description = "dae Service";
        Documentation = "https://github.com/daeuniverse/dae";
        After = [ "network-online.target" "systemd-sysctl.service" ];
        Wants = [ "network-online.target" ];
      };

      serviceConfig = {
        User = "root";
        ExecStartPre = "${lib.getExe cfg.package} validate -c /etc/dae/config.dae";
        ExecStart = "${lib.getExe cfg.package} run --disable-timestamp -c /etc/dae/config.dae";
        ExecReload = "${lib.getExe cfg.package} reload $MAINPID";
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        Restart = "on-abnormal";
        Type = "notify";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
