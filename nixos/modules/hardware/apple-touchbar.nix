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

    services.udev.packages = with pkgs; [ tiny-dfr ];
  };
}
