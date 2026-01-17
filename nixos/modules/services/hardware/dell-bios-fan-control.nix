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
    boot.kernelModules = [ "i8k" ];
    environment.systemPackages = [ cfg.package ];
    # see ref in aur: https://aur.archlinux.org/cgit/aur.git/tree/dell-bios-fan-control.service?h=dell-bios-fan-control-git
    systemd.services.dell-bios-fan-control = {
      description = "Disables BIOS control of fans at boot.";
      wants = [ "dell-bios-fan-control-resume.service" ];
      wantedBy = [ "multi-user.target" ];
      before = [ "i8kmon.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe cfg.package} 0";
        ExecStop = "${lib.getExe cfg.package} 1";
      };
    };

    # see ref in aur: https://aur.archlinux.org/cgit/aur.git/tree/dell-bios-fan-control-resume.service?h=dell-bios-fan-control-git
    systemd.services.dell-bios-fan-control-resume = {
      description = "Restart dell-bios-fan-control on resume.";
      wants = [ "dell-bios-fan-control.service" ];
      wantedBy = [ "suspend.target" ];
      after = [ "suspend.target" ];
      serviceConfig = {
        Type = "oneshot";
        # re: sleep, see: https://github.com/NixOS/nixpkgs/pull/439978#discussion_r2404279441
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 30";
        ExecStart = "${config.systemd.package}/bin/systemctl restart dell-bios-fan-control.service";
      };
    };
  };
}
