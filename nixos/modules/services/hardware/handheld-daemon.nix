{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.services.handheld-daemon;
in
{
  options.services.handheld-daemon = {
    enable = mkEnableOption "Enable Handheld Daemon";
    package = mkPackageOption pkgs "handheld-daemon" { };

    user = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        The user to run Handheld Daemon with.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    environment.sessionVariables = {
      # This is a `configfs` mount-point for interacting with `hrtimer`.  On
      # immutable Linuxes, it's `/var/trig_sysfs_config`.  On mutable ones, it's
      # `/config`.
      #
      # See also https://docs.kernel.org/iio/iio_configfs.html
      HHD_MOUNT_TRIG_SYSFS = "$STATE_DIRECTORY/trig_sysfs_config";
    };

    systemd.services.handheld-daemon = {
      description = "Handheld Daemon";

      wantedBy = [ "multi-user.target" ];

      restartIfChanged = true;

      serviceConfig = {
        ExecStart = "${ lib.getExe cfg.package } --user ${ cfg.user }";
        Nice = "-12";
        Restart = "on-failure";
        RestartSec = "10";
      };
    };
  };

  meta.maintainers = [ maintainers.appsforartists ];
}
