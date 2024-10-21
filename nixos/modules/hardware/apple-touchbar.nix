{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.apple.touchBar;
  format = pkgs.formats.toml { };
  cfgFile = format.generate "config.toml" cfg.settings;
in
{
  options.hardware.apple.touchBar = {
    enable = mkEnableOption "support for the Touch Bar on some Apple laptops using tiny-dfr";

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for tiny-dfr. See
        <https://github.com/WhatAmISupposedToPutHere/tiny-dfr/blob/master/share/tiny-dfr/config.toml>
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> config.services.udev.enable;
        message = "Touch Bar support via tiny-dfr requires udev.";
      }
    ];

    environment.etc."tiny-dfr/config.toml".source = cfgFile;

    systemd.services."systemd-backlight@backlight:228200000.display-pipe.0" = {};
    systemd.services."systemd-backlight@backlight:appletb_backlight" = {};

    systemd.services.tiny-dfr = {
      enable = true;
      description = "Tiny Apple silicon touch bar daemon";
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "systemd-logind.service"
        "dev-tiny_dfr_display.device"
        "dev-tiny_dfr_backlight.device"
        "dev-tiny_dfr_display_backlight.device"
      ] ++ optional config.boot.plymouth.enable "plymouth-quit.service";
      bindsTo = [
        "dev-tiny_dfr_display.device"
        "dev-tiny_dfr_backlight.device"
        "dev-tiny_dfr_display_backlight.device"
      ];
      serviceConfig = {
        ExecStart = "${pkgs.tiny-dfr}/bin/tiny-dfr";
        Restart = "always";
      };
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="adp|appletbdrm", TAG-="master-of-seat", ENV{ID_SEAT}="seat-touchbar"

      SUBSYSTEM=="input", ATTR{name}=="Apple Inc. Touch Bar Display Touchpad", ENV{ID_SEAT}="seat-touchbar"
      SUBSYSTEM=="input", ATTR{name}=="MacBookPro17,1 Touch Bar", ENV{ID_SEAT}="seat-touchbar"
      SUBSYSTEM=="input", ATTR{name}=="Mac14,7 Touch Bar", ENV{ID_SEAT}="seat-touchbar"

      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", ATTR{idProduct}=="8302", ATTR{bConfigurationValue}=="1", ATTR{bConfigurationValue}="0", ATTR{bConfigurationValue}="2"

      SUBSYSTEM=="input", ATTR{name}=="Apple Inc. Touch Bar Display Touchpad", TAG+="systemd", ENV{SYSTEMD_WANTS}="tiny-dfr.service"
      SUBSYSTEM=="input", ATTR{name}=="MacBookPro17,1 Touch Bar", TAG+="systemd", ENV{SYSTEMD_WANTS}="tiny-dfr.service"
      SUBSYSTEM=="input", ATTR{name}=="Mac14,7 Touch Bar", TAG+="systemd", ENV{SYSTEMD_WANTS}="tiny-dfr.service"

      SUBSYSTEM=="drm", KERNEL=="card[0-9]*", DRIVERS=="adp|appletbdrm", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/tiny_dfr_display"

      SUBSYSTEM=="backlight", KERNEL=="appletb_backlight", DRIVERS=="hid-appletb-bl", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/tiny_dfr_backlight"
      SUBSYSTEM=="backlight", KERNEL=="228200000.display-pipe.0", DRIVERS=="panel-summit", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/tiny_dfr_backlight"

      SUBSYSTEM=="backlight", KERNEL=="apple-panel-bl", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/tiny_dfr_display_backlight"
      SUBSYSTEM=="backlight", KERNEL=="gmux_backlight", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/tiny_dfr_display_backlight"
      SUBSYSTEM=="backlight", KERNEL=="intel_backlight", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/tiny_dfr_display_backlight"
      SUBSYSTEM=="backlight", KERNEL=="acpi_video0", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/tiny_dfr_display_backlight"
    '';
  };
}
