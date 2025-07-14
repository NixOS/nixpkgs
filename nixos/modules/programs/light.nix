{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.light;

in
{
  options = {
    programs.light = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to install Light backlight control command
          and udev rules granting access to members of the "video" group.
        '';
      };

      brightnessKeys = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable brightness control with keyboard keys.

            This is mainly useful for minimalistic (desktop) environments. You
            may want to leave this disabled if you run a feature-rich desktop
            environment such as KDE, GNOME or Xfce as those handle the
            brightness keys themselves. However, enabling brightness control
            with this setting makes the control independent of X, so the keys
            work in non-graphical ttys, so you might want to consider using this
            instead of the default offered by the desktop environment.

            Enabling this will turn on {option}`services.actkbd`.
          '';
        };

        step = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = ''
            The percentage value by which to increase/decrease brightness.
          '';
        };

        minBrightness = lib.mkOption {
          type = lib.types.numbers.between 0 100;
          default = 0.1;
          description = ''
            The minimum authorized brightness value, e.g. to avoid the
            display going dark.
          '';
        };

      };

    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.light ];
    services.udev.packages = [ pkgs.light ];
    services.actkbd = lib.mkIf cfg.brightnessKeys.enable {
      enable = true;
      bindings =
        let
          light = "${pkgs.light}/bin/light";
          step = builtins.toString cfg.brightnessKeys.step;
          minBrightness = builtins.toString cfg.brightnessKeys.minBrightness;
        in
        [
          {
            keys = [ 224 ];
            events = [ "key" ];
            # -N is used to ensure that value >= minBrightness
            command = "${light} -N ${minBrightness} && ${light} -U ${step}";
          }
          {
            keys = [ 225 ];
            events = [ "key" ];
            command = "${light} -A ${step}";
          }
        ];
    };
  };
}
