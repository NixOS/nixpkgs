{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.wooting;
in
{
  options.hardware.wooting = {
    enable = mkEnableOption "support for Wooting keyboards";
    xinput.enable = mkEnableOption "xinput support for Wooting keyboards";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.wootility ];

    services.udev.packages =
      [ pkgs.wooting-udev-rules ]
      ++ (optional cfg.xinput.enable pkgs.wooting-xinput-udev-rules);

    systemd.services = mkIf cfg.xinput.enable {
      "wooting-xinput@" = {
        description = "xboxdrv userspace driver for native Xbox 360 interface of Wooting keyboards";
        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${pkgs.xboxdrv}/bin/xboxdrv --type xbox360 --device-by-id 03eb:%I --silent --quiet \
              --detach-kernel-driver --mimic-xpad
          '';
        };
      };
    };
  };
}
