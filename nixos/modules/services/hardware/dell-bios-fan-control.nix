{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.hardware.dell-bios-fan-control;
in
{
  meta.maintainers = with lib.maintainers; [ rickyelopez ];

  options.services.hardware.dell-bios-fan-control = {
    enable = lib.mkEnableOption "One-shot service to disable dell bios fan control on startup";
    package = lib.mkPackageOption pkgs "dell-bios-fan-control" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.dell-bios-fan-control = {
      description = "Disable Dell bios fan control";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Tyep = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe cfg.package} 0";
        ExecStop = "${lib.getExe cfg.package} 1";
        Restart = "no";
      };
    };
  };
}
