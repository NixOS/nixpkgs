# INTEGRATION NOTES:
# Buffyboard integrates as a virtual device in /dev/input
# which reads touch or pointer events from other input devices
# and generates events based on where those map to the keys it renders to the framebuffer.
#
# Buffyboard generates these events whether or not its onscreen keyboard is actually visible.
# Hence special care is needed if running anything which claims ownership of the display (such as a desktop environment),
# to avoid unwanted input events being triggered during normal desktop operation.
#
# Desktop users are recommended to either:
# 1. Stop buffyboard once your DE is started.
#   e.g. `services.buffyboard.unitConfig.Conflicts = [ "my-de.service" ];`
# 2. Configure your DE to ignore input events from buffyboard (product-id=25209; vendor-id=26214; name=rd)
#   e.g. `echo 'input "26214:25209:rd" events disabled' > ~/.config/sway/config`

{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.buffyboard;
  ini = pkgs.formats.ini { };
in
{
  meta.maintainers = with lib.maintainers; [ colinsane ];

  options = {
    services.buffyboard = with lib; {
      enable = mkEnableOption "buffyboard framebuffer keyboard (on-screen keyboard)";
      package = mkPackageOption pkgs "buffybox" { };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra CLI arguments to pass to buffyboard.
        '';
        example = [
          "--geometry=1920x1080@640,0"
          "--dpi=192"
          "--rotate=2"
          "--verbose"
        ];
      };

      configFile = mkOption {
        type = lib.types.path;
        default = ini.generate "buffyboard.conf" (lib.filterAttrsRecursive (_: v: v != null) cfg.settings);
        defaultText = lib.literalExpression ''ini.generate "buffyboard.conf" cfg.settings'';
        description = ''
          Path to an INI format configuration file to provide Buffyboard.
          By default, this is generated from whatever you've set in `settings`.
          If specified manually, then `settings` is ignored.

          For an example config file see [here](https://gitlab.postmarketos.org/postmarketOS/buffybox/-/blob/master/buffyboard/buffyboard.conf)
        '';
      };

      settings = mkOption {
        description = ''
          Settings to include in /etc/buffyboard.conf.
          Every option here is strictly optional:
          Buffyboard will use its own baked-in defaults for those options left unset.
        '';
        type = types.submodule {
          freeformType = ini.type;

          options.input.pointer = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = ''
              Enable or disable the use of a hardware mouse or other pointing device.
            '';
          };
          options.input.touchscreen = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = ''
              Enable or disable the use of the touchscreen.
            '';
          };

          options.theme.default = mkOption {
            type = types.either types.str (
              types.enum [
                null
                "adwaita-dark"
                "breezy-dark"
                "breezy-light"
                "nord-dark"
                "nord-light"
                "pmos-dark"
                "pmos-light"
              ]
            );
            default = null;
            description = ''
              Selects the default theme on boot. Can be changed at runtime to the alternative theme.
            '';
          };
          options.quirks.fbdev_force_refresh = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = ''
              If true and using the framebuffer backend, this triggers a display refresh after every draw operation.
              This has a negative performance impact.
            '';
          };
        };
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.buffyboard = {
      # upstream provides the service (including systemd hardening): we just configure it to start by default
      # and override ExecStart so as to optionally pass extra arguments
      serviceConfig.ExecStart = [
        "" # clear default ExecStart
        (utils.escapeSystemdExecArgs (
          [
            (lib.getExe' cfg.package "buffyboard")
            "--config-override"
            cfg.configFile
          ]
          ++ cfg.extraFlags
        ))
      ];
      wantedBy = [ "getty.target" ];
      before = [ "getty.target" ];
    };
  };
}
