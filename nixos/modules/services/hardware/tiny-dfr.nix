{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  toml = pkgs.formats.toml { };
  filterConfig = lib.filterAttrsRecursive (_: v: v != null);
  configFile = toml.generate "tiny-dfr.conf" (filterConfig cfg.settings);

  cfg = config.services.tiny-dfr;
in
{
  options = {
    services.tiny-dfr = {
      enable = lib.mkEnableOption "tiny-dfr, a tiny Apple touchbar daemon";
      package = lib.mkPackageOption pkgs "tiny-dfr" { };

      settings = mkOption {
        description = ''
          Freeform settings for tiny-dfr.

          See [the template config](https://github.com/WhatAmISupposedToPutHere/tiny-dfr/blob/master/share/tiny-dfr/config.toml)
          for a list of available options.

          Passing `null` as a value will cause the key to not be set and the value from the template to be used.
        '';
        default = { };
        type = types.submodule {
          freeformType = toml.type;
          options = {
            MediaLayerDefault = mkOption {
              description = "Whether the media layer (non-Fn keys) should be displayed by default. Hold the fn key to change layers.";
              type = types.nullOr types.bool;
              default = false;
              example = true;
            };
            ShowButtonOutlines = mkOption {
              description = "Whether to show the outline around icons.";
              type = types.nullOr types.bool;
              default = true;
              example = false;
            };
            EnablePixelShift = mkOption {
              description = "Shift the entire touchbar screen by a small amount periodically.";
              type = types.nullOr types.bool;
              default = false;
              example = true;
            };
            FontTemplate = mkOption {
              description = ''
                The fontconfig pattern to use.

                See the "Font Names" section in [the fontconfig docs](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html)
                for more information.
              '';
              type = types.nullOr types.str;
              default = "";
              example = ":bold";
            };
            AdaptiveBrightness = mkOption {
              description = "Whether the touchbar screen should follow the primary screen's brightness.";
              type = types.nullOr types.bool;
              default = null;
              example = true;
            };
            ActiveBrightness = mkOption {
              description = "The brightness to use when adaptive brightness is disabled.";
              type = types.nullOr types.ints.u8;
              default = null;
              example = 155;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];

    # TODO: migrate to systemd.packages
    systemd.services.tiny-dfr =
      let
        backlightDevices = [
          "dev-tiny_dfr_display.device"
          "dev-tiny_dfr_backlight.device"
          "dev-tiny_dfr_display_backlight.device"
        ];
      in
      {
        enable = true;
        description = "Tiny Apple Silicon touch bar daemon";
        after = [
          "systemd-user-sessions.service"
          "getty@tty1.service"
          "plymouth-quit.service"
          "systemd-logind.service"
        ] ++ backlightDevices;
        bindsTo = backlightDevices;
        startLimitIntervalSec = 30;
        startLimitBurst = 2;
        restartTriggers = [
          cfg.package
          configFile
        ];
        serviceConfig = {
          Type = "simple";
          ExecStart = lib.getExe cfg.package;
        };
      };

    systemd.units = {
      "systemd-backlight@backlight:228200000.display-pipe.0.service" = { };
      "systemd-backlight@backlight:appletb_backlight.service" = { };
    };

    environment.etc."tiny-dfr/config.toml" = {
      source = configFile;
    };
  };

  meta.maintainers = with lib.maintainers; [ soopyc ];
}
