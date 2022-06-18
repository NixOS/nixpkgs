{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.wooting;
  xinput-rules = pkgs.writeTextFile {
    name = "71-wooting-xinput.rules";
    text = ''
      # Wooting One
      SUBSYSTEM=="usb", ENV{PRODUCT}=="3eb/ff01/*", ENV{INTERFACE}=="255/93/1", TAG+="systemd", ENV{SYSTEMD_WANTS}="wooting-xinput@03eb:ff01"

      # Wooting Two
      SUBSYSTEM=="usb", ENV{PRODUCT}=="3eb/ff02/*", ENV{INTERFACE}=="255/93/1", TAG+="systemd", ENV{SYSTEMD_WANTS}="wooting-xinput@03eb:ff02"

      # Wooting Two Lekker Edition
      SUBSYSTEM=="usb", ENV{PRODUCT}=="31e3/1210/*", ENV{INTERFACE}=="255/93/1", TAG+="systemd", ENV{SYSTEMD_WANTS}="wooting-xinput@31e3:1210"

      # Wooting Two HE
      SUBSYSTEM=="usb", ENV{PRODUCT}=="31e3/1220/*", ENV{INTERFACE}=="255/93/1", TAG+="systemd", ENV{SYSTEMD_WANTS}="wooting-xinput@31e3:1220"
    '';
  };
in
{
  options.hardware.wooting = {
    enable = mkEnableOption "support for Wooting keyboards";
    xinput.enable = mkEnableOption "xinput support for Wooting keyboards";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.wootility ];

    services.udev.packages = [
      pkgs.wooting-udev-rules
      (optional cfg.xinput.enable xinput-rules)
    ];

    systemd.services = mkIf cfg.xinput.enable {
      "wooting-xinput@" = {
        description = "xboxdrv userspace driver for native Xbox 360 interface of Wooting keyboards";
        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${pkgs.xboxdrv}/bin/xboxdrv --type xbox360 --device-by-id %I --silent --quiet \
              --detach-kernel-driver --mimic-xpad
          '';
        };
        unitConfig."StopWhenUnneeded" = true;
      };
    };
  };
}
