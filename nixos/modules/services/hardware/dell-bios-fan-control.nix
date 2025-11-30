{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.dell-bios-fan-control;
  package = cfg.package;
in
{
  options.services.dell-bios-fan-control = {
    enable = lib.mkEnableOption "Disable BIOS fan control on some older Dell laptops.";
    package = lib.mkPackageOption pkgs "dell-bios-fan-control" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];

    systemd.services.dell-bios-fan-control = {
      description = "Disables BIOS control of fans at boot";
      wantedBy = [ "multi-user.target" ];
      wants = [ "dell-bios-fan-control-resume.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${package}/bin/dell-bios-fan-control 0";
        ExecStop = "${package}/bin/dell-bios-fan-control 1";
        RemainAfterExit = true;
      };
    };

    systemd.services.dell-bios-fan-control-resume = {
      description = "Restart dell-bios-fan-control on resume";
      after = [ "suspend.target" ];
      wantedBy = [ "suspend.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/sh -c '${pkgs.coreutils}/bin/sleep 30 && ${config.systemd.package}/bin/systemctl --no-block restart dell-bios-fan-control.service'";
      };
    };
  };
}
