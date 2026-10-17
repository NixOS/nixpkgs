{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.clipmenu;
in
{

  options.services.clipmenu = {
    enable = lib.mkEnableOption "clipmenu, the clipboard management daemon";

    package = lib.mkPackageOption pkgs "clipmenu" { };

    cm_debug = lib.mkOption {
      type = lib.types.bool;
      description = "turn on debugging output";
      default = false;
    };

    cm_dir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Specify the base directory to store the cache dir in";
      default = null;
    };

    cm_max_clips = lib.mkOption {
      type = lib.types.ints.unsigned;
      description = "soft maximum number of clips to store, 0 for inf. At $CM_MAX_CLIPS + 10, the number of clips is reduced to $CM_MAX_CLIPS";
      default = 1000;
    };

    cm_oneshot = lib.mkOption {
      type = lib.types.bool;
      description = "run once immediately, do not loop";
      default = false;
    };

    cm_own_clipboard = lib.mkOption {
      type = lib.types.bool;
      description = "take ownership of the clipboard. Note: this may cause missed copies if some other application also handles the clipboard directly";
      default = false;
    };

    cm_selections = lib.mkOption {
      type = lib.types.str;
      description = "list of the selections to manage";
      default = [
        "clipboard"
        "primary"
      ];
    };

    cm_ignore_window = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "disable recording the clipboard in windows where the windowname matches the given regex (e.g. a password manager), do not ignore any windows if unset or empty";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.clipmenu =
      {
        enable = true;
        description = "Clipboard management daemon";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${cfg.package}/bin/clipmenud";

        environment.CM_DEBUG = builtins.toString cfg.cm_debug;
        environment.CM_MAX_CLIPS = builtins.toString cfg.cm_max_clips;
        environment.CM_ONESHOT = builtins.toString cfg.cm_oneshot;
        environment.CM_OWN_CLIPBOARD = builtins.toString cfg.cm_own_clipboard;
        environment.CM_SELECTIONS = builtins.toString cfg.cm_selections;
      }
      // lib.optionalAttrs (cfg.cm_dir != null) {
        environment.CM_DIR = cfg.cm_dir;
      }
      // lib.optionalAttrs (cfg.cm_ignore_window != null) {
        environment.CM_DIR = cfg.cm_ignore_window;
      };

    environment.systemPackages = [ cfg.package ];
  };
}
