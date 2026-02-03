{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.xencelabs;
in
{
  meta.maintainers = with lib.maintainers; [
    naitrate
  ];

  options = {
    hardware.xencelabs = {
    enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable Xencelabs hardware udev rules, and service.
        '';
    };
    package = lib.mkPackageOption pkgs "xencelabs" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.services.xencelabs = lib.mkIf cfg.enable {
    description = "Xencelabs Multi-User Service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "chmod 777 /tmp/qtsingleapp-Xencel-fb8d-lockfile";
        Restart = "on-failure";
    };
  };
}
