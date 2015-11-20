# Dunst daemon.

{ config, lib, pkgs, ... }:

let
    cfg = config.services.dunst;
    mkBoolStr = b: if b then "yes" else "false";

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
'' +
    (if cfg.global.dmenu != null then
        '' dmenu = ${cfg.global.dmenu}''
    else
        ""
    ) +
    (if cfg.global.browser != null then
        '' browser = ${cfg.global.browser}''
    else
        ""
    ) +
''
    icon_position       = ${cfg.global.iconPosition}
'' +
    (if cfg.global.iconFolders != null then
        '' icon_folders = ${cfg.global.iconFolders}''
    else
        ""
    ) +
''

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
                        Font
                    '';
                };

                allowMarkup = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                        Allow a small subset of html markup:
                          <b>bold</b>
                          <i>italic</i>
                          <s>strikethrough</s>
                          <u>underline</u>
                        For a complete reference see
                        <http://developer.gnome.org/pango/stable/PangoMarkupFormat.html>.
                        If markup is not allowed, those tags will be stripped
                        out of the message.
                    '';
                };

                format = mkOption {
                    type = types.str;
                    default = ''<b>%s</b>\n%b'';
                    description = ''
                        The format of the message.  Possible variables are:
                          %a  appname
                          %s  summary
                          %b  body
                          %i  iconname (including its path)
                          %I  iconname (without its path)
                          %p  progress value if set ([  0%] to [100%]) or nothing
                        Markup is allowed
                    '';
                };

                sort = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                        Sort messages by urgency.
                    '';
                };

                indicateHidden = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                        Show how many messages are currently hidden (because of
                        geometry).
                    '';
                };

                alignment = mkOption {
                    type = types.str;
                    default = "right";
                    description = ''
                        Alignment of message text.
                        Possible values are "left", "center" and "right".
                    '';
                };

                bounceFreq = mkOption {
                    type = types.int;
                    default = 0;
                    description = ''
                        The frequency with wich text that is longer than the
                        notification window allows bounces back and forth.
                        This option conflicts with "word_wrap".
                        Set to 0 to disable.
                    '';
                };

                showAgeThreshold = mkOption {
                    type = types.int;
                    default = 0;
                    description = ''
                        Show age of message if message is older than
                        show_age_threshold seconds.
                        Set to -1 to disable.
                    '';
                };

                wordWrap = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                        Split notifications into multiple lines if they don't
                        fit into geometry.
                    '';
                };

                ignoreNewline = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                        Ignore newlines '\n' in notifications.
                    '';
                };

                geometry = mkOption {
                    type = types.str;
                    default = "320x5-3+19";
                    description = ''
                        The geometry of the window:
                          [{width}]x{height}[+/-{x}+/-{y}]
                        The geometry of the message window.
                        The height is measured in number of notifications
                        everything else in pixels. If the width is omitted but
                        the height is given ("-geometry x2"), the message window
                        expands over the whole screen (dmenu-like). If width is
                        0, the window expands to the longest message displayed.
                        A positive x is measured from the left, a negative from
                        the right side of the screen. Y is measured from the top
                        and down respectevly.
                        The width can be negative. In this case the actual width
                        is the screen width minus the width defined in within
                        the geometry option.
                    '';
                };

                shrink = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                        Shrink window if it's smaller than the width.  Will be
                        ignored if width is 0.
                    '';
                };

                transparency = mkOption {
                    type = types.int;
                    default = 0;
                    description = ''
                        The transparency of the window.  Range: [0; 100].
                        This option will only work if a compositing
                        windowmanager is present (e.g. xcompmgr, compiz, etc.).
                    '';
                };

                idlethreshold = mkOption {
                    type = types.int;
                    default = 120;
                    description = ''
                        Don't remove messages, if the user is idle (no mouse or
                        keyboard input) for longer than idle_threshold seconds.
                        Set to 0 to disable.
                    '';
                };

                monitor = mkOption {
                    type = types.int;
                    default = 0;
                    description = ''
                        Which monitor should the notifications be displayed on.
                    '';
                };

                follow = mkOption {
                    type = types.str;
                    default = "mouse";
                    description = ''
                        Display notification on focused monitor.  Possible modes
                        are:
                          mouse: follow mouse pointer
                          keyboard: follow window with keyboard focus
                          none: don't follow anything

                        "keyboard" needs a windowmanager that exports the
                        _NET_ACTIVE_WINDOW property.
                        This should be the case for almost all modern
                        windowmanagers.

                        If this option is set to mouse or keyboard, the monitor
                        option will be ignored.
                    '';
                };

                stickyHistory = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                        Should a notification popped up from history be sticky
                        or timeout as if it would normally do.
                    '';
                };

                historyLength = mkOption {
                    type = types.int;
                    default = 20;
                    description = ''
                        Maximum amount of notifications kept in history
                    '';
                };

                showIndicators = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                        Display indicators for URLs (U) and actions (A).
                    '';
                };

                lineHeight = mkOption {
                    type = types.int;
                    default = 0;
                    description = ''
                        The height of a single line.  If the height is smaller
                        than the font height, it will get raised to the font
                        height.
                        This adds empty space above and under the text.
                    '';
                };

                separatorHeight = mkOption {
                    type = types.int;
                    default = 2;
                    description = ''
                        Draw a line of "separatpr_height" pixel height between
                        two notifications.
                        Set to 0 to disable.
                    '';
                };

                padding = mkOption {
                    type = types.int;
                    default = 8;
                    description = ''
                        Padding between text and separator.
                    '';
                };

                horizontalPadding = mkOption {
                    type = types.int;
                    default = 8;
                    description = ''
                        Horizontal padding.
                    '';
                };

                separatorColor = mkOption {
                    type = types.str;
                    default = "frame";
                    description = ''
                        Define a color for the separator.
                        possible values are:
                         * auto: dunst tries to find a color fitting to the background;
                         * foreground: use the same color as the foreground;
                         * frame: use the same color as the frame;
                         * anything else will be interpreted as a X color.
                    '';
                };

                startupNotification = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                        Print a notification on startup.
                        This is mainly for error detection, since dbus
                        (re-)starts dunst automatically after a crash.
                    '';
                };

                dmenu = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = ''
                        dmenu path.
                    '';
                };

                browser = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = ''
                        Browser for opening urls in context menu.
                    '';
                };

                iconPosition = mkOption {
                    type = types.str;
                    default = "off";
                    description = ''
                        Align icons left/right/off
                    '';
                };

                iconFolders = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    description = ''
                        Paths to default icons.
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
                        Close notification.
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
                        Redisplay last message(s).
                        On the US keyboard layout "grave" is normally above TAB
                        and left of "1".
                    '';
                };

                context = mkOption {
                    type = types.str;
                    default = "ctrl+shift+period";
                    description = ''
                        Context menu.
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
            wantedBy    = [ "multi-user.target" ];

            serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst -config ${dunstConf}";
        };

    };

}

