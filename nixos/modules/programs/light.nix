{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.light;
  light = "${pkgs.light}/bin/light" + optionalString (cfg.devicePath != null) " -s ${cfg.devicePath}";

in
{
  options = {
    programs.light = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install Light backlight control command
          and udev rules granting access to members of the "video" group.
        '';
      };

      minimumBrightness = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Set minimum cap on the brightness value, as some controllers set
          the display to be pitch black at a 0 (or higher).
        '';
      };

      devicePath = mkOption {
        type = with types; nullOr string;
        default = null;
        example = "sysfs/backlight/intel_backlight";
        description = ''
          Specify device target path.  Use <command>light -L</command> to
          list available devices.
        '';
      };

      mediaKeys = {

        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable brightness control with keyboard media keys.
            You want to leave this disabled if you run a desktop environment
            like KDE, Gnome, Xfce, etc, as those handle such things themselves.
            You might want to enable this if you run a minimalistic desktop
            environment or work from bare linux ttys/framebuffers.
            Enabling this will turn on <option>services.actkbd</option>.
          '';
        };

        step = mkOption {
          type = types.int;
          default = 1;
          description = ''
            The value by which to increment/decrement brightness on media keys.
            See light(1) for allowed values.
          '';
        };

      };

    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.light ];
    services.udev.packages = [ pkgs.light ];

    services.actkbd = mkIf cfg.mediaKeys.enable {
      enable = true;
      bindings = [
        { keys = [ 224 ]; events = [ "key" "rep" ]; command = "${light} -U ${toString cfg.mediaKeys.step}"; }
        { keys = [ 225 ]; events = [ "key" "rep" ]; command = "${light} -A ${toString cfg.mediaKeys.step}"; }
      ];
    };

    system.activationScripts.setup-light = ''
      ${light} -N ${toString cfg.minimumBrightness}
      ${light} -O
    '';

    systemd.services.light = {
      description = "Save/restore backlight state";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${light} -I";
        ExecStop = "${light} -O";
      };
    };

  };
}
