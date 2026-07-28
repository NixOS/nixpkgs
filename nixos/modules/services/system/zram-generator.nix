{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zram-generator;
  settingsFormat = pkgs.formats.ini { };
in
{
  meta = {
    maintainers = with lib.maintainers; [ nickcao ];
  };

  options.services.zram-generator = {
    enable = lib.mkEnableOption "Systemd unit generator for zram devices";

    package = lib.mkPackageOption pkgs "zram-generator" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        Configuration for zram-generator,
        see <https://github.com/systemd/zram-generator> for documentation.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isEnabled "ZRAM")
    ];

    systemd.packages = [ cfg.package ];
    systemd.services."systemd-zram-setup@" = {
      path = [ pkgs.util-linux ]; # for mkswap
      # Restart on switch does swapoff -> reset -> reconfigure -> swapon.
      # Besides risking OOM when swap is in use, the reset races with udev
      # still holding /dev/zramN open after swapoff: the kernel rejects the
      # reset with EBUSY (disk_openers > 0), the device stays initialized,
      # and the following ExecStart fails to write comp_algorithm/disksize
      # (systemd/zram-generator#226). The unit only "changes" due to store
      # path churn, so keep the device across switches; real config changes
      # need a reboot or manual restart.
      restartIfChanged = false;
    };

    environment.etc."systemd/zram-generator.conf".source =
      settingsFormat.generate "zram-generator.conf" cfg.settings;
  };
}
