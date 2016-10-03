# Dunst daemon.

{ config, lib, pkgs, ... }:

# Maintainers: siddharthist, matthiasbeyer

let
  cfg = config.services.dunst;
  mkBoolStr = b: if b then "yes" else "false";

  dmenuConfig = if cfg.global.dmenu != null then
      '' dmenu = ${cfg.global.dmenu}''
    else
      "";

  browserConfig = if cfg.global.browser != null then
      '' browser = ${cfg.global.browser}''
    else
      "";

  iconFoldersConfig = if cfg.global.iconFolders != null then
      '' icon_folders = ${cfg.global.iconFolders}''
    else
      "";

  dunstConf = with cfg; builtins.toFile "dunstrc" ''
[global]
  font        = ${global.font}
  allow_markup    = ${mkBoolStr global.allowMarkup}
  plain_text   =  ${mkBoolStr global.plainText}
  format        = ${global.format}
  sort        = ${mkBoolStr global.sort}
  indicate_hidden   = ${mkBoolStr global.indicateHidden}
  alignment       = ${global.alignment}
  bounce_freq     = ${toString global.bounceFreq}
  show_age_threshold  = ${toString global.showAgeThreshold}
  word_wrap       = ${mkBoolStr global.wordWrap}
  ignore_newline    = ${mkBoolStr global.ignoreNewline}
  geometry      = ${global.geometry}
  shrink        = ${mkBoolStr global.shrink}
  transparency    = ${toString global.transparency}
  idle_threshold    = ${toString global.idlethreshold}
  monitor       = ${toString global.monitor}
  follow        = ${global.follow}
  sticky_history    = ${mkBoolStr global.stickyHistory}
  history_length    = ${toString global.historyLength}
  show_indicators   = ${mkBoolStr global.showIndicators}
  line_height     = ${toString global.lineHeight}
  separator_height  = ${toString global.separatorHeight}
  padding       = ${toString global.padding}
  horizontal_padding  = ${toString global.horizontalPadding}
  separator_color   = ${global.separatorColor}
  startup_notification= ${mkBoolStr global.startupNotification}
  icon_position     = ${global.iconPosition}

  ${dmenuConfig}
  ${browserConfig}
  ${iconFoldersConfig}

[frame]
  width = ${toString frame.width}
  color = ${frame.color}

[shortcuts]
  close     = ${shortcuts.close}
  close_all   = ${shortcuts.closeAll}
  history   = ${shortcuts.history}
  context   = ${shortcuts.context}

[urgency_low]
  background  = ${urgency.low.background}
  foreground  = ${urgency.low.foreground}
  timeout   = ${toString urgency.low.timeout}

[urgency_normal]
  background  = ${urgency.normal.background}
  foreground  = ${urgency.normal.foreground}
  timeout   = ${toString urgency.normal.timeout}

[urgency_critical]
  background  = ${urgency.critical.background}
  foreground  = ${urgency.critical.foreground}
  timeout   = ${toString urgency.critical.timeout}

${extraConfig}
'';

in
with lib;
{
  options.services.dunst = {
    enable = mkEnableOption "dunst daemon";

    global = {
      font = mkOption {
        type = types.str;
        default = "Monospace 8";
        description = ''
        '';
      };

      allowMarkup = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow a small subset of html markup in notifications and formats
        '';
      };

      plainText = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Treat incoming notifications as plain text
        '';
      };

      format = mkOption {
        type = types.str;
        default = ''<b>%s</b>\n%b'';
        description = ''
        '';
      };

      sort = mkOption {
        type = types.bool;
        default = true;
        description = ''
        '';
      };

      indicateHidden = mkOption {
        type = types.bool;
        default = true;
        description = ''
        '';
      };

      alignment = mkOption {
        type = types.str;
        default = "right";
        description = ''
        '';
      };

      bounceFreq = mkOption {
        type = types.int;
        default = 0;
        description = ''
        '';
      };

      showAgeThreshold = mkOption {
        type = types.int;
        default = 0;
        description = ''
        '';
      };

      wordWrap = mkOption {
        type = types.bool;
        default = true;
        description = ''
        '';
      };

      ignoreNewline = mkOption {
        type = types.bool;
        default = false;
        description = ''
        '';
      };

      geometry = mkOption {
        type = types.str;
        default = "320x5-3+19";
        description = ''
        '';
      };

      shrink = mkOption {
        type = types.bool;
        default = false;
        description = ''
        '';
      };

      transparency = mkOption {
        type = types.int;
        default = 0;
        description = ''
        '';
      };

      idlethreshold = mkOption {
        type = types.int;
        default = 120;
        description = ''
        '';
      };

      monitor = mkOption {
        type = types.int;
        default = 0;
        description = ''
        '';
      };

      follow = mkOption {
        type = types.str;
        default = "mouse";
        description = ''
        '';
      };

      stickyHistory = mkOption {
        type = types.bool;
        default = true;
        description = ''
        '';
      };

      historyLength = mkOption {
        type = types.int;
        default = 20;
        description = ''
        '';
      };

      showIndicators = mkOption {
        type = types.bool;
        default = true;
        description = ''
        '';
      };

      lineHeight = mkOption {
        type = types.int;
        default = 0;
        description = ''
        '';
      };

      separatorHeight = mkOption {
        type = types.int;
        default = 2;
        description = ''
        '';
      };

      padding = mkOption {
        type = types.int;
        default = 8;
        description = ''
        '';
      };

      horizontalPadding = mkOption {
        type = types.int;
        default = 8;
        description = ''
        '';
      };

      separatorColor = mkOption {
        type = types.str;
        default = "frame";
        description = ''
        '';
      };

      startupNotification = mkOption {
        type = types.bool;
        default = false;
        description = ''
        '';
      };

      dmenu = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
        '';
      };

      browser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
        '';
      };

      iconPosition = mkOption {
        type = types.str;
        default = "off";
        description = ''
        '';
      };

      iconFolders = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
        '';
      };

    };


    frame = {
      width = mkOption {
        type = types.int;
        default = 3;
        description = ''
        '';
      };

      color = mkOption {
        type = types.str;
        default = ''#aaaaaa'';
        description = ''
        '';
      };

    };

    shortcuts = {
      close = mkOption {
        type = types.str;
        default = "ctrl+space";
        description = ''
        '';
      };

      closeAll = mkOption {
        type = types.str;
        default = "ctrl+shift+space";
        description = ''
        '';
      };

      history = mkOption {
        type = types.str;
        default = "ctrl+Escape";
        description = ''
        '';
      };

      context = mkOption {
        type = types.str;
        default = "ctrl+shift+period";
        description = ''
        '';
      };

    };

    urgency = {
      low = {
        background = mkOption {
          type = types.str;
          default = ''#222222'';
          description = ''
          '';
        };

        foreground = mkOption {
          type = types.str;
          default = ''#888888'';
          description = ''
          '';
        };

        timeout = mkOption {
          type = types.int;
          default = 10;
          description = ''
          '';
        };
      };
      normal = {
        background = mkOption {
          type = types.str;
          default = ''#285577'';
          description = ''
          '';
        };

        foreground = mkOption {
          type = types.str;
          default = ''#ffffff'';
          description = ''
          '';
        };

        timeout = mkOption {
          type = types.int;
          default = 10;
          description = ''
          '';
        };
      };
      critical = {
        background = mkOption {
          type = types.str;
          default = ''#900000'';
          description = ''
          '';
        };

        foreground = mkOption {
          type = types.str;
          default = ''#ffffff'';
          description = ''
          '';
        };

        timeout = mkOption {
          type = types.int;
          default = 0;
          description = ''
          '';
        };

      };
    };

    extraConfig = mkOption {
      type = types.string;
      default = "";
      description = "Extra configuration to append to the config file.";
    };

  };


###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.dunst ];
    systemd.user.services.dunst = {
      description = "Dunst: lightweight and customizable notification daemon";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.dunst}/bin/dunst -config ${dunstConf}";
        Restart = "always";
        RestartSec = 3;
      };
      environment.DISPLAY = ":${toString (
        let display = config.services.xserver.display;
        in if display != null then display else 0
      )}";
    };
  };
}
