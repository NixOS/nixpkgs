{ config, pkgs, ... }:
{
  imports = [
    ../.
  ];
  # Give TLP service more control over battery
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    kernelModules = [
      "acpi_call"
    ];
  };

  # See https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
  services.tlp.extraConfig = ''
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
'';

  # Temporary fix for cpu throttling issues visible in the kernel log
  # (journalctl -k) by setting the same temperature limits used by
  # Window$
  # See https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues
  systemd.services.cpu-throttling = {
    enable = true;
    description = "Sets the offset to 3 °C, so the new trip point is 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    path = [ pkgs.msr-tools ];
    script = "wrmsr -a 0x1a2 0x3000000";
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  systemd.timers.cpu-throttling = {
    enable = true;
    description = "Set cpu heating limit to 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    timerConfig = {
      OnActiveSec = 60;
      OnUnitActiveSec = 60;
      Unit = "cpu-throttling.service";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  # Enable S3 suspend state: you have to manually follow the
  # instructions shown here: https://delta-xi.net/#056 in order to
  # produce the ACPI patched table. Put the CPIO archive in /boot and
  # then enable the following lines
  # boot.kernelParams = [
  #   "mem_sleep_default=deep"
  # ];
  # boot.initrd.prepend = [
  #   "/boot/acpi_override"
  # ];
}
