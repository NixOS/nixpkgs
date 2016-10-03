# Dunst daemon.

{ config, lib, pkgs, ... }:

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

    dunstConf = builtins.toFile "dunstrc" ''
[global]
    font                = ${cfg.global.font}
    allow_markup        = ${mkBoolStr cfg.global.allowMarkup}
    format              = ${cfg.global.format}
    sort                = ${mkBoolStr cfg.global.sort}
    indicate_hidden     = ${mkBoolStr cfg.global.indicateHidden}
    alignment           = ${cfg.global.alignment}
    bounce_freq         = ${toString cfg.global.bounceFreq}
    show_age_threshold  = ${toString cfg.global.showAgeThreshold}
    word_wrap           = ${mkBoolStr cfg.global.wordWrap}
    ignore_newline      = ${mkBoolStr cfg.global.ignoreNewline}
    geometry            = ${cfg.global.geometry}
    shrink              = ${mkBoolStr cfg.global.shrink}
    transparency        = ${toString cfg.global.transparency}
    idle_threshold      = ${toString cfg.global.idlethreshold}
    monitor             = ${toString cfg.global.monitor}
    follow              = ${cfg.global.follow}
    sticky_history      = ${mkBoolStr cfg.global.stickyHistory}
    history_length      = ${toString cfg.global.historyLength}
    show_indicators     = ${mkBoolStr cfg.global.showIndicators}
    line_height         = ${toString cfg.global.lineHeight}
    separator_height    = ${toString cfg.global.separatorHeight}
    padding             = ${toString cfg.global.padding}
    horizontal_padding  = ${toString cfg.global.horizontalPadding}
    separator_color     = ${cfg.global.separatorColor}
    startup_notification= ${mkBoolStr cfg.global.startupNotification}
    icon_position       = ${cfg.global.iconPosition}

    ${dmenuConfig}
    ${browserConfig}
    ${iconFoldersConfig}

[frame]
    width = ${toString cfg.frame.width}
    color = ${cfg.frame.color}

[shortcuts]
    close       = ${cfg.shortcuts.close}
    close_all   = ${cfg.shortcuts.closeAll}
    history     = ${cfg.shortcuts.history}
    context     = ${cfg.shortcuts.context}

[urgency_low]
    background  = ${cfg.urgency.low.background}
    foreground  = ${cfg.urgency.low.foreground}
    timeout     = ${toString cfg.urgency.low.timeout}

[urgency_normal]
    background  = ${cfg.urgency.normal.background}
    foreground  = ${cfg.urgency.normal.foreground}
    timeout     = ${toString cfg.urgency.normal.timeout}

[urgency_critical]
    background  = ${cfg.urgency.critical.background}
    foreground  = ${cfg.urgency.critical.foreground}
    timeout     = ${toString cfg.urgency.critical.timeout}
'';

in
with lib;
{

    ###### interface

    options = {

        services.dunst = {

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
        };
    };


###### implementation

    config = mkIf config.services.dunst.enable {

        environment.systemPackages = [ pkgs.dunst pkgs.dmenu ];

        systemd.services.dunst = {
            description = "Dunst Daemon";
            after       = [ "multi-user.target" ];
            wants       = [ "graphical.target" ];

            serviceConfig = {
              ExecStart = "${pkgs.dunst}/bin/dunst -config ${dunstConf} ";
              Type = "forking";
            };
        };

    };

}

