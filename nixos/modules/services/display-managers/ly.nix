{
  config,
  lib,
  pkgs,
  ...
}:

let
  dmcfg = config.services.displayManager;
  xcfg = config.services.xserver;
  xdmcfg = xcfg.displayManager;
  cfg = config.services.displayManager.ly;
  xEnv = config.systemd.services.display-manager.environment;

  ly = cfg.package.override { x11Support = cfg.x11Support; };

  iniFmt = pkgs.formats.iniWithGlobalSection { };

  inherit (lib)
    concatMapStrings
    attrNames
    getAttr
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    ;

  xserverWrapper = pkgs.writeShellScript "xserver-wrapper" ''
    ${concatMapStrings (n: ''
      export ${n}="${getAttr n xEnv}"
    '') (attrNames xEnv)}
    exec systemd-cat -t xserver-wrapper ${xdmcfg.xserverBin} ${toString xdmcfg.xserverArgs} "$@"
  '';

  removeNullValues = (_: value: value != null && value != "");
  finalSettings = cfg.settings // cfg.extraSettings;
  cfgFile = iniFmt.generate "config.ini" {
    globalSection = lib.filterAttrs removeNullValues finalSettings;
  };
in
{
  options = {
    services.displayManager.ly = {
      enable = mkEnableOption "ly as the display manager";
      x11Support = mkOption {
        description = "Whether to enable support for X11";
        type = lib.types.bool;
        default = true;
      };

      package = mkPackageOption pkgs [ "ly" ] { };

      extraSettings = mkOption {
        type = with lib.types; attrsOf iniFmt.lib.types.atom;
        default = { };
        description = ''Non-typed settings'';
      };

      settings = {
        animation = mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "doom"
              "matrix"
              "colormix"
              "gameoflife"
            ]
          );
          default = null;
          description = "The active animation";
        };
        allow_empty_password = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Allow empty password or not when authenticating";
        };
        animation_timeout_sec = mkOption {
          # Limit is 4096 because zig stores animation_timeout_sec as u12
          type = lib.types.addCheck lib.types.ints.u16 (x: x <= 4096);
          default = 0;
          description = ''
            Stop the animation after some time
            0 -> Run forever
            1..2e12 -> Stop the animation after this many seconds
          '';
        };
        asterisk = mkOption {
          type = lib.types.addCheck (lib.types.nullOr lib.types.str) (x: 1 == builtins.stringLength x);
          default = "*";
          description = ''
            The character used to mask the password
            You can either type it directly as a UTF-8 character (like *), or use a UTF-32
            codepoint (for example 0x2022 for a bullet point)
            If null, the password will be hidden
            Note: you can use a # by escaping it like so: \#
          '';
        };
        auth_fails = mkOption {
          type = lib.types.int;
          default = 10;
          description = ''
            The number of failed authentications before a special animation is played... ;)
            If set to 0, the animation will never be played
          '';
        };
        battery_id = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Identifier for battery whose charge to display at top left
            Primary battery is usually BAT0 or BAT1
            If set to null, battery status won't be shown
          '';
        };
        auto_login_service = mkOption {
          default = "ly-autologin";
          description = ''
            Automatic login configuration
            This feature allows Ly to automatically log in a user without password prompt.
            IMPORTANT: Both auto_login_user and auto_login_session must be set for this to work.
            Autologin only happens once at startup - it won't re-trigger after logout.

            PAM service name to use for automatic login
            The default service (ly-autologin) uses pam_permit to allow login without password
            The appropriate platform-specific PAM configuration (ly-autologin) will be used automatically
          '';
        };
        auto_login_session = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.path
            ]
          );
          default = null;
          description = ''
            Session name to launch automatically
            To find available session names, check the .desktop files in:
              - /usr/share/xsessions/ (for X11 sessions)
              - /usr/share/wayland-sessions/ (for Wayland sessions)
            Use the filename without .desktop extension, or the value of DesktopNames field
            Examples: "i3", "sway", "gnome", "plasma", "xfce"
            If null, automatic login is disabled
          '';
        };
        auto_login_user = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Username to automatically log in
            Must be a valid user on the system
            If null, automatic login is disabled
          '';
        };
        bg = mkOption {
          type = lib.types.str;
          default = "0x00000000";
          description = "Background color id, default is black";
        };
        fg = mkOption {
          type = lib.types.str;
          default = "0x00FFFFFF";
          description = "Foreground color id, default is white";
        };
        bigclock = mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "en"
              "fa"
            ]
          );
          default = "en";
          description = ''
            Change the state and language of the big clock
              none -> Disabled (default)
              en   -> English
              fa   -> Farsi
          '';
        };
        bigclock_12hr = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set bigclock to 12-hour notation.";
        };
        bigclock_seconds = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set bigclock to show the seconds.";
        };
        blank_box = mkOption {
          type = lib.types.bool;
          default = true;
          description = "Blank main box background. Setting to false will make it transparent.";
        };
        border_fg = mkOption {
          type = lib.types.str;
          default = "0x00FFFFFF";
          description = "Border foreground color id.";
        };
        box_title = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Title to show at the top of the main box. If set to null, none will be shown.";
        };
        brightness_up_cmd = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.package
            ]
          );
          default = null;
          description = "Brightness decrease command ";
        };
        brightness_up_key = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "F6";
          description = "Brightness increase key (F1-F12), null to disable ";
        };
        brightness_down_cmd = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.package
            ]
          );
          default = null;
          description = "Brightness decrease command ";
        };
        brightness_down_key = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "F5";
          description = "Brightness decrease key (F1-F12), null to disable ";
        };
        clear_password = mkOption {
          type = lib.types.bool;
          default = true;
          description = "Erase password input on failure.";
        };
        clock = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Format string for clock in top right corner (see strftime specification). Example: %c
            If null, the clock won't be shown
          '';
        };
        cmatrix_fg = mkOption {
          type = lib.types.str;
          default = "0x0000FF00";
          description = "CMatrix animation foreground color id";
        };
        cmatrix_head_col = mkOption {
          type = lib.types.str;
          default = "0x01FFFFFF";
          description = "CMatrix animation character string head color id";
        };
        cmatrix_min_codepoint = mkOption {
          type = lib.types.str;
          default = "0x21";
          description = "CMatrix animation minimum codepoint. It uses a 16-bit integer";
        };
        cmatrix_max_codepoint = mkOption {
          type = lib.types.str;
          default = "0x7B";
          description = "CMatrix animation maximum codepoint. It uses a 16-bit integer";
        };
        colormix_col1 = mkOption {
          type = lib.types.str;
          default = "0x00FF0000";
          description = "Color mixing animation first color id";
        };
        colormix_col2 = mkOption {
          type = lib.types.str;
          default = "0x000000FF";
          description = "Color mixing animation second color id";
        };
        colormix_col3 = mkOption {
          type = lib.types.str;
          default = "0x20000000";
          description = "Color mixing animation third color id";
        };
        custom_sessions = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.path
            ]
          );
          default = null;
          description = ''
            Custom sessions directory
            You can specify multiple directories,
            e.g. $CONFIG_DIRECTORY/ly/custom-sessions:$PREFIX_DIRECTORY/share/custom-sessions
          '';
        };
        default_input = mkOption {
          type = lib.types.enum [
            "info_line"
            "session"
            "login"
            "password"
          ];
          default = "login";
          description = ''
            Input box active by default on startup
            Available inputs: info_line, session, login, password
          '';
        };
        doom_fire_height = mkOption {
          type = lib.types.addCheck lib.types.int (x: x >= 1 && x <= 9);
          default = 6;
          description = "DOOM animation fire height (1 through 9)";
        };
        doom_fire_spread = mkOption {
          type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 4);
          default = 2;
          description = "DOOM animation fire spread (0 through 4)";
        };
        doom_top_color = mkOption {
          type = lib.types.str;
          default = "0x009F2707";
          description = "DOOM animation custom top color (low intensity flames)";
        };
        doom_middle_color = mkOption {
          type = lib.types.str;
          default = "0x00C78F17";
          description = "DOOM animation custom middle color (medium intensity flames)";
        };
        doom_bottom_color = mkOption {
          type = lib.types.str;
          default = "0x00FFAF27";
          description = "DOOM animation custom bottom color (high intensity flames)";
        };
        dur_file_path = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.path
            ]
          );
          default = null;
          description = "Dur file path";
        };
        dur_x_offset = mkOption {
          type = lib.types.int;
          default = 0;
          description = "Dur offset x direction";
        };
        dur_y_offset = mkOption {
          type = lib.types.int;
          default = 0;
          description = "Dur offset y direction";
        };
        edge_margin = mkOption {
          type = lib.types.int;
          default = 0;
          description = "Set margin to the edges of the DM (useful for curved monitors)";
        };
        error_bg = mkOption {
          type = lib.types.str;
          default = "0x00000000";
          description = "Error background color id";
        };
        error_fg = mkOption {
          type = lib.types.str;
          default = "0x01FF0000";
          description = "Error foreground color id, default is red and bold";
        };
        full_color = mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Render true colors (if supported)
            If false, output will be in eight-color mode
            All eight-color mode color codes:
            TB_DEFAULT              0x0000
            TB_BLACK                0x0001
            TB_RED                  0x0002
            TB_GREEN                0x0003
            TB_YELLOW               0x0004
            TB_BLUE                 0x0005
            TB_MAGENTA              0x0006
            TB_CYAN                 0x0007
            TB_WHITE                0x0008
            If full color is off, the styling options still work. The colors are
            always 32-bit values with the styling in the most significant byte.
            Note: If using the dur_file animation option and the dur file's color range
            is saved as 256 with this option disabled, the file will not be drawn.
          '';
        };
        gameoflife_entropy_interval = mkOption {
          type = lib.types.int;
          default = 10;
          description = ''
            Game of Life entropy interval (0 = disabled, >0 = add entropy every N generations)
            0 -> Pure Conway's Game of Life (will eventually stabilize)
            10 -> Add entropy every 10 generations (recommended for continuous activity)
            50+ -> Less frequent entropy for more natural evolution
          '';
        };
        gameoflife_fg = mkOption {
          type = lib.types.str;
          default = "0x0000FF00";
          description = "Game of Life animation foreground color id";
        };
        gameoflife_frame_delay = mkOption {
          type = lib.types.int;
          default = 6;
          description = ''
            Game of Life frame delay (lower = faster animation, higher = slower)
            1-3 -> Very fast animation
            6 -> Default smooth animation speed
            10+ -> Slower, more contemplative speed
          '';
        };
        gameoflife_initial_density = mkOption {
          type = lib.types.float;
          default = 0.4;
          description = ''
            Game of Life initial cell density (0.0 to 1.0)
            0.1 -> Sparse, minimal activity
            0.4 -> Balanced activity (recommended)
            0.7+ -> Dense, chaotic patterns
          '';
        };
        hibernate_cmd = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.package
            ]
          );
          default = null;
          description = "Command executed when pressing hibernate key (can be null)";
        };
        hibernate_key = mkOption {
          type = lib.types.str;
          default = "F4";
          description = "Specifies the key used for hibernate (F1-F12)";
        };
        hide_borders = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Remove main box borders";
        };
        hide_key_hints = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Remove power management command hints";
        };
        hide_keyboard_locks = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Remove keyboard lock states from the top right corner";
        };
        hide_version_string = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Remove version number from the top left corner";
        };
        inactivity_cmd = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.package
            ]
          );
          default = null;
          description = "Command executed when no input is detected for a certain time";
        };
        inactivity_delay = mkOption {
          type = lib.types.int;
          default = 0;
          description = "Executes a command after a certain amount of seconds";
        };
        initial_info_text = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Initial text to show on the info line";
        };
        input_len = mkOption {
          type = lib.types.int;
          default = 34;
          description = "Input boxes length";
        };
        lang = mkOption {
          type = lib.types.enum [
            "ar"
            "bg"
            "cat"
            "cs"
            "de"
            "en"
            "es"
            "fr"
            "it"
            "ja_JP"
            "lv"
            "pl"
            "pt"
            "pt_BR"
            "ro"
            "ru"
            "sr"
            "sv"
            "tr"
            "uk"
            "zh_CN"
          ];
          default = "en";
          description = ''
            Active language
            Available languages are found in $CONFIG_DIRECTORY/ly/lang/
          '';
        };
        login_cmd = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Command executed when logging in
            If null, no command will be executed
            Important: the code itself must end with `exec "$@"` in order to launch the session!
            You can also set environment variables in there, they'll persist until logout
          '';
        };
        login_defs_path = mkOption {
          type = lib.types.str;
          default = "/etc/login.defs";
          description = ''
            Path for login.defs file (used for listing all local users on the system on
            Linux)
          '';
        };
        logout_cmd = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Command executed when logging out
            If null, no command will be executed
            Important: the session will already be terminated when this command is executed, so
            no need to add `exec "$@"` at the end
          '';
        };
        ly_log = mkOption {
          type = lib.types.externalPath;
          default = "/var/log/ly.log";
          description = "General log file path";
        };
        margin_box_h = mkOption {
          type = lib.types.int;
          default = 2;
          description = "Main box horizontal margin";
        };
        margin_box_v = mkOption {
          type = lib.types.int;
          default = 1;
          description = "Main box vertical margin";
        };
        min_refresh_delta = mkOption {
          type = lib.types.int;
          default = 5;
          description = "Event timeout in milliseconds";
        };
        numlock = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set numlock on/off at startup";
        };
        path = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "/run/current-system/sw/bin";
          description = ''
            Default PATH
            If null, ly doesn't set a PATH
          '';
        };
        restart_cmd = mkOption {
          type = lib.types.str;
          default = "/run/current-system/systemd/bin/systemctl reboot";
          description = "Command executed when pressing restart_key";
        };
        restart_key = mkOption {
          type = lib.types.str;
          default = "F2";
          description = "Specifies the key used for restart (F1-F12)";
        };
        save = mkOption {
          type = lib.types.bool;
          default = true;
          description = "Save the current desktop and login as defaults, and load them on startup";
        };
        service_name = mkOption {
          type = lib.types.str;
          default = "ly";
          description = "Service name (set to ly to use the provided pam config file)";
        };
        session_log = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = ".local/state/ly-session.log";
          description = ''
            Session log file path
            This will contain stdout and stderr of Wayland sessions
            By default it's saved in the user's home directory
            Important: due to technical limitations, X11 and shell sessions aren't supported, which
            means you won't get any logs from those sessions.
            If null, no session log will be created
          '';
        };
        setup_cmd = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.package
            ]
          );
          default = null;
          description = "Setup command executed when starting Ly (before the TTY is taken control of)";
        };
        shutdown_cmd = mkOption {
          type = lib.types.str;
          default = "/run/current-system/systemd/bin/systemctl poweroff";
          description = "Command executed when pressing shutdown_key";
        };
        shutdown_key = mkOption {
          type = lib.types.str;
          default = "F1";
          description = "Specifies the key used for shutdown (F1-F12)";
        };
        sleep_cmd = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Command executed when pressing sleep key (can be null)";
        };
        sleep_key = mkOption {
          type = lib.types.str;
          default = "F3";
          description = "Specifies the key used for sleep (F1-F12)";
        };
        start_cmd = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Command executed when starting Ly (before the TTY is taken control of)
            If null, no command will be executed
          '';
        };
        text_in_center = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Center the session name.";
        };
        vi_default_mode = mkOption {
          type = lib.types.enum [
            "normal"
            "insert"
          ];
          default = "normal";
          description = "Default vi mode";
        };
        vi_mode = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable vi keybindings";
        };
        waylandsessions = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Wayland desktop environments
            You can specify multiple directories,
            e.g. $PREFIX_DIRECTORY/share/wayland-sessions:$PREFIX_DIRECTORY/local/share/wayland-sessions
          '';
        };
        x_cmd = mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.package
            ]
          );
          default = null;
          description = ''
            Xorg server command
            If null, the xinitrc session will be hidden
          '';
        };
        xauth_cmd = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Xorg xauthority edition tool
          '';
        };
        xinitrc = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "~/.xinitrc";
          description = ''
            xinitrc
            If null, the xinitrc session will be hidden
          '';
        };
        xsessions = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Xorg desktop environments
            You can specify multiple directories,
            e.g. $PREFIX_DIRECTORY/share/xsessions:$PREFIX_DIRECTORY/local/share/xsessions
          '';
        };
        tty = mkOption {
          type = lib.types.int;
          default = 1;
          description = "The TTY number where ly will run";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = !dmcfg.autoLogin.enable;
        message = ''
          ly doesn't support auto login.
        '';
      }
    ];

    security.pam.services.ly = {
      startSession = true;
      unixAuth = true;
      enableGnomeKeyring = lib.mkDefault config.services.gnome.gnome-keyring.enable;
    };

    environment = {
      etc."ly/config.ini".source = cfgFile;
      systemPackages = [ ly ];

      pathsToLink = [ "/share/ly" ];
    };

    services = {
      dbus.packages = [ ly ];

      displayManager = {
        enable = true;
        execCmd = "exec /run/current-system/sw/bin/ly";

        # Set this here so users get eval errors if they change it.
        ly.settings = {
          setup_cmd = dmcfg.sessionData.wrapper;
          waylandsessions = "${dmcfg.sessionData.desktops}/share/wayland-sessions";
          x_cmd = lib.optionalString xcfg.enable xserverWrapper;
          xauth_cmd = lib.optionalString xcfg.enable "${pkgs.xorg.xauth}/bin/xauth";
          xsessions = lib.optionalString xcfg.enable "${dmcfg.sessionData.desktops}/share/xsessions";
          tty = 1;
        };
      };

      xserver = {
        # To enable user switching, allow ly to allocate displays dynamically.
        display = null;
      };
    };

    systemd = {
      # We're not using the upstream unit, so copy these:
      # https://github.com/fairyglade/ly/blob/master/res/ly.service
      services.display-manager = {
        after = [
          "systemd-user-sessions.service"
          "plymouth-quit-wait.service"
        ];

        serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          TTYPath = "/dev/tty${toString finalSettings.tty}";
          TTYReset = "yes";
          TTYVHangup = "yes";
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ vonfry ];
}
