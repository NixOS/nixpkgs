{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dunst;
  reservedSections = [
    "global" "experimental" "frame" "shortcuts"
    "urgency_low" "urgency_normal" "urgency_critical"
  ];
  defaultGlobalConfig = {
    monitor = 0;
    follow = "mouse";
    geometry = "300x5-30+20";
    progress_bar = true;
    progress_bar_height = 10;
    progress_bar_frame_width = 1;
    progress_bar_min_width = 150;
    progress_bar_max_width = 300;
    indicate_hidden = true;
    shrink = false;
    transparency = 0;
    notification_height = 0;
    separator_height = 2;
    padding = 8;
    horizontal_padding = 8;
    text_icon_padding = 0;
    frame_width = 3;
    frame_color = "#aaaaaa";
    separator_color = "frame";
    sort = true;
    idle_threshold = 120;
    font = "Monospace 8";
    line_height = 0;
    markup = "full";
    format = "<b>%s</b>\\n%b";
    alignment = "left";
    vertical_alignment = "center";
    show_age_threshold = 60;
    word_wrap = true;
    ellipsize = "middle";
    ignore_newline = false;
    stack_duplicates = true;
    hide_duplicate_count = false;
    show_indicators = true;
    icon_position = "left";
    min_icon_size = 0;
    max_icon_size = 32;
    icon_path = "";
    sticky_history = true;
    history_length = 20;
    dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";
    browser = "${pkgs.firefox}/bin/firefox -new-tab";
    always_run_script = true;
    title = "Dunst";
    class = "Dunst";
    startup_notification = false;
    verbosity = "mesg";
    corner_radius = 0;
    ignore_dbusclose = false;
    force_xwayland = false;
    force_xinerama = false;
    mouse_left_click = "close_current";
    mouse_middle_click = "close_current";
    mouse_right_click = "close_all";
  };
  defaultShortcutConfig = {};
  defaultFrameConfig = {};
  defaultUrgencyConfigLow = {
    background = "#222222";
    foreground = "#888888";
    timeout = 10;
  };
  defaultUrgencyConfigNormal = {
    background = "#285577";
    foreground = "#ffffff";
    timeout = 10;
  };
  defaultUrgencyConfigCritical = {
    background = "#900000";
    foreground = "#ffffff";
    frame_color = "#ff0000";
    timeout = 0;
  };
  defaultExperimentalConfig = {
    per_monitor_dpi = false;
  };
in {

options.services.dunst = {

  enable = mkEnableOption "the dunst notifications daemon";

  iconDirs = mkOption {
    type = with types; listOf path;
    default = [];
    example = literalExample ''
      [ "''${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita/48x48" ]
    '';
    description = ''
      Paths to icon folders.
    '';
  };

  extraArgs = mkOption {
    type = with types; listOf str;
    default = [];
    description = ''
      Extra command line options for dunst
    '';
  };

  globalConfig = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = defaultGlobalConfig;
    description = ''
      The global configuration section for dunst. Values will be merged into the defaults.
    '';
    example = ''
      {
        font = "Monospace 12";
        sort = true;
        idle_threshold = 0;
      }
    '';
  };

  shortcutConfig = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = defaultShortcutConfig;
    description = ''
      The shortcut configuration for dunst. Values will be merged into the defaults.
    '';
    example = ''
      {
        close = "mod3+h";
      }
    '';
  };

  frameConfig = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = defaultFrameConfig;
    description = ''
      The frame configuration for dunst. Values will be merged into the defaults.
    '';
    example = ''
      {
        width = 0;
        color = "#000000";
      }
    '';
  };

  urgencyConfig = {
    low = mkOption {
      type = with types; attrsOf (oneOf [bool str int]);
      default = defaultUrgencyConfigLow;
      description = ''
        The low urgency section of the dunst configuration. Values will be merged into the defaults.
      '';
      example = ''
        {
          background = "#ffffff";
          foreground = "#888888";
          timeout = 60;
        }
      '';
    };
    normal = mkOption {
      type = with types; attrsOf (oneOf [bool str int]);
      default = defaultUrgencyConfigNormal;
      description = ''
        The normal urgency section of the dunst configuration. Values will be merged into the defaults.
      '';
      example = ''
        {
          background = "#ffffff";
          foreground = "#111111";
          timeout = 60;
        }
      '';
    };
    critical = mkOption {
      type = with types; attrsOf (oneOf [bool str int]);
      default = defaultUrgencyConfigCritical;
      description = ''
        The critical urgency section of the dunst configuration. Values will be merged into the defaults.
      '';
      example = ''
        {
          background = "#ff0000";
          foreground = "#111111";
          timeout = 0;
        }
      '';
    };
  };

  experimentalConfig = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = defaultExperimentalConfig;
    description = ''
      The experimental configuration for dunst. Values will be merged into the defaults.
    '';
    example = ''
      {
        per_monitor_dpi = true;
      }
    '';
  };

  rules = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = {};
    description = ''
       These rules allow the conditional modification of notifications.

       Note that rule names may not be one of the following
       keywords already used internally:
         ${concatStringsSep ", " reservedSections}
       There are 2 parts in configuring a rule: Defining when a rule
       matches and should apply (called filtering in the man page)
       and then the actions that should be taken when the rule is
       matched (called modifying in the man page).
    '';
    example = literalExample ''
      signed_off = {
        appname = "Pidgin";
        summary = "*signed off*";
        urgency = "low";
        script = "pidgin-signed-off.sh";
      };
    '';
  };

};

config =
  let
    dunstValue = v: with builtins;
      let
        err = t: v: abort
          ("dunstValue: " +
           "${t} not supported: ${toPretty {} (toString v)}");
        isValid = v: any (f: f v) [isInt isString isBool];
      in if isValid v
           then toJSON v
           else err "this value is" v;
    dunstConfig = lib.generators.toINI {
      mkKeyValue = lib.generators.mkKeyValueDefault {
        mkValueString = dunstValue;
      } "=";
    } allOptions;
    allOptions = {
      global = defaultGlobalConfig // cfg.globalConfig;
      shortcut = defaultShortcutConfig // cfg.shortcutConfig;
      frameConfig = defaultFrameConfig // cfg.frameConfig;
      experimental = defaultExperimentalConfig // cfg.experimentalConfig;
      urgency_normal = defaultUrgencyConfigNormal // cfg.urgencyConfig.normal;
      urgency_low = defaultUrgencyConfigLow // cfg.urgencyConfig.low;
      urgency_critical = defaultUrgencyConfigCritical // cfg.urgencyConfig.critical;
    } // cfg.rules;

    iconPath = concatStringsSep ":" cfg.iconDirs;
    iconArg = if lib.stringLength iconPath == 0 then [] else [ "-icon_path" iconPath ];

    dunst-args = [
      "-config" (pkgs.writeText "dunstrc" dunstConfig)
    ] ++ iconArg ++ cfg.extraArgs;

  in mkIf cfg.enable {

    assertions = flip mapAttrsToList cfg.rules (name: conf: {
      assertion = ! elem name reservedSections;
      message = ''
        dunst config: ${name} is a reserved keyword. Please choose
        a different name for the rule.
      '';
    });

    systemd.user.services.dunst.serviceConfig.ExecStart = [ "" "${pkgs.dunst}/bin/dunst ${escapeShellArgs dunst-args}" ];
    # [ "" ... ] is needed to overwrite the ExecStart directive from the upstream service file

    systemd.packages = [ pkgs.dunst ];
    services.dbus.packages = [ pkgs.dunst ];
  };

}
