{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types mkDefault;
  inherit (builtins) mapAttrs;
  inherit (lib.strings) optionalString;
  inherit (pkgs) emptty;
  cfg = config.services.xserver.displayManager.emptty;

  defaultConfig = {
    TTY_NUMBER = 1;
    SWITCH_TTY = true;
    PRINT_ISSUE = true;
    PRINT_MOTD = true;
    DEFAULT_USER = null;
    DEFAULT_SESSION = null;
    DEFAULT_SESSION_ENV = null;
    AUTOLOGIN = false;
    AUTOLOGIN_SESSION = null;
    AUTOLOGIN_SESSION_ENV = null;
    AUTOLOGIN_MAX_RETRY = null;
    LANG = null;
    DBUS_LAUNCH = true;
    ALWAYS_DBUS_LAUNCH = false;
    XINITRC_LAUNCH = false;
    VERTICAL_SELECTION = false;
    LOGGING = null;
    LOGGING_FILE = null;
    DYNAMIC_MOTD = false;
    DYNAMIC_MOTD_PATH = "/etc/emptty/motd-gen.sh";
    MOTD_PATH = "/etc/emptty/motd";
    FG_COLOR = null;
    BG_COLOR = null;
    DISPLAY_START_SCRIPT = null;
    DISPLAY_STOP_SCRIPT = null;
    ENABLE_NUMLOCK = false;
    SESSION_ERROR_LOGGING = null;
    SESSION_ERROR_LOGGING_FILE = null;
    DEFAULT_XAUTHORITY = null;
    ROOTLESS_XORG = null;
    IDENTIFY_ENVS = false;
    HIDE_ENTER_LOGIN = false;
    HIDE_ENTER_PASSWORD = false;
  };

  availableColors = [
    "BLACK"
    "RED"
    "GREEN"
    "YELLOW"
    "BLUE"
    "PURPLE"
    "CYAN"
    "WHITE"
    "LIGHT_BLACK"
    "LIGHT_RED"
    "LIGHT_GREEN"
    "LIGHT_YELLOW"
    "LIGHT_BLUE"
    "LIGHT_PURPLE"
    "LIGHT_CYAN"
    "LIGHT_WHITE"
  ];

  empttyToString = type:
    if builtins.typeOf type == "bool"
    then
      (
        if type
        then "true"
        else "false"
      )
    else builtins.toString type;

  optionsToString = optionsSet:
    lib.attrsets.mapAttrsToList
      (name: value: (
        optionalString (value != null) "${name}=${empttyToString value}"
      ))
      optionsSet;
in
{
  options = {
    services.xserver.displayManager.emptty = {
      enable = mkEnableOption (lib.mdDoc "Whether to enable emptty as the display manager.");

      package = mkOption {
        type = types.package;
        default = emptty;
        defaultText = lib.mdDoc "pkgs.emptty";
        description = lib.mdDoc "Derivation to use for emptty.";
      };

      restart = mkOption {
        type = types.bool;
        default = true;
        # TODO: set up autologin to see if this is actually true for emptty. it
        # is true for greetd
        description = lib.mdDoc ''
          Whether to restart emptty when it terminates (e.g. on failure).
          This is usually desirable so a user can always log in, but should be disabled when using autologin,
          because every emptty restart will trigger the autologin again.
        '';
      };

      configuration = mkOption {
        default = defaultConfig;
        description = lib.mdDoc ''
          Configuration options which are passed to emptty as environment
          variables. Each option is documented in [emptty's README.md](https://github.com/tvrzna/emptty/blob/master/README.md)

          The ``XORG_ARGS`` options is not included here;
          ``config.services.xserver.displayManager.xserverArgs`` should be used
          instead.
        '';
        type = types.submodule {
          options = {
            TTY_NUMBER = mkOption {
              type = types.int;
              default = defaultConfig.TTY_NUMBER;
              description = lib.mdDoc "TTY where emptty will start.";
            };
            SWITCH_TTY = mkOption {
              type = types.bool;
              default = defaultConfig.SWITCH_TTY;
              description = lib.mdDoc "Enables switching to defined TTY number.";
            };
            PRINT_ISSUE = mkOption {
              type = types.bool;
              default = defaultConfig.PRINT_ISSUE;
              description = lib.mdDoc "Enables printing of /etc/issue in daemon mode.";
            };
            PRINT_MOTD = mkOption {
              type = types.bool;
              default = defaultConfig.PRINT_MOTD;
              description = lib.mdDoc "Enables printing of default motd, /etc/emptty/motd or /etc/emptty/motd-gen.sh.";
            };
            DEFAULT_USER = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.DEFAULT_USER;
              description = lib.mdDoc "Preselected user, if AUTOLOGIN is enabled, this user is logged in.";
            };
            DEFAULT_SESSION = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.DEFAULT_SESSION;
              description = lib.mdDoc "Preselected desktop session, if user does not use ``emptty`` file. Has lower priority than ``AUTOLOGIN_SESSION``.";
            };
            DEFAULT_SESSION_ENV = mkOption {
              type = types.nullOr (types.enum [ "xorg" "wayland" ]);
              default = defaultConfig.DEFAULT_SESSION_ENV;
              description = lib.mdDoc "Optional environment of preselected desktop session, if user does not use ``emptty`` file.";
            };
            AUTOLOGIN = mkOption {
              type = types.bool;
              default = defaultConfig.AUTOLOGIN;
              description = lib.mdDoc "Enables Autologin, if DEFAULT_USER is defined and part of nopasswdlogin group.";
            };
            AUTOLOGIN_SESSION = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.AUTOLOGIN_SESSION;
              description =
                lib.mdDoc
                  "The default session used, if Autologin is enabled. If session is not found in list of sessions, it proceeds to manual selection.";
              example = "i3";
            };
            AUTOLOGIN_SESSION_ENV = mkOption {
              type = types.nullOr (types.enum [ "xorg" "wayland" ]);
              default = defaultConfig.AUTOLOGIN_SESSION_ENV;
              description = lib.mdDoc "Optional environment of autologin desktop session.";
            };
            AUTOLOGIN_MAX_RETRY = mkOption {
              type = types.nullOr types.int;
              default = defaultConfig.AUTOLOGIN_MAX_RETRY;
              description = lib.mdDoc "If Autologin is enabled and session does not start correctly, the number of retries in short period is kept to eventually stop the infinite loop of restarts. -1 is for infinite retries, 0 is for no retry.";
            };
            LANG = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.LANG;
              description = lib.mdDoc "Default LANG, if user does not have set own in init script.";
              example = "en_US.UTF-8";
            };
            DBUS_LAUNCH = mkOption {
              type = types.bool;
              default = defaultConfig.DBUS_LAUNCH;
              description = lib.mdDoc "Starts \"dbus-launch\" before desktop command. After end of session \"dbus-daemon\" is interrupted. If user config is handled as script (does not contain Exec option), this config is overridden to false.";
            };
            ALWAYS_DBUS_LAUNCH = mkOption {
              type = types.bool;
              default = defaultConfig.ALWAYS_DBUS_LAUNCH;
              description = lib.mdDoc "Starts \"dbus-launch\" before desktop command in any case, ``DBUS_LAUNCH`` value is ignored. It also starts even if XINITRC_LAUNCH is set to true. After end of session \"dbus-daemon\" is interrupted.";
            };
            XINITRC_LAUNCH = mkOption {
              type = types.bool;
              default = defaultConfig.XINITRC_LAUNCH;
              description = lib.mdDoc "Starts Xorg desktop with calling \"~/.xinitrc\" script, if is true, file exists and selected WM/DE is Xorg session, it overrides DBUS_LAUNCH.";
            };
            VERTICAL_SELECTION = mkOption {
              type = types.bool;
              default = defaultConfig.XINITRC_LAUNCH;
              description = lib.mdDoc "Prints available WM/DE each on new line instead of printing on single line.";
            };
            LOGGING = mkOption {
              type = types.nullOr (types.enum [ "default" "appending" "disabled" ]);
              default = defaultConfig.LOGGING;
              description = lib.mdDoc "Defines the way, how is logging handled. Possible values are \"default\", \"appending\" or \"disabled\".";
            };
            LOGGING_FILE = mkOption {
              type = types.nullOr (types.oneOf [ types.string types.path ]);
              default = defaultConfig.LOGGING_FILE;
              description = lib.mdDoc "Overrides path of log file";
              example = "/var/log/emptty/$\{TTY_NUMBER}.log";
            };
            DYNAMIC_MOTD = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.DYNAMIC_MOTD;
              description = lib.mdDoc "Allows to use dynamic motd script to generate custom MOTD.";
            };
            DYNAMIC_MOTD_PATH = mkOption {
              type = types.nullOr (types.oneOf [ types.package types.string types.path ]);
              default = defaultConfig.DYNAMIC_MOTD_PATH;
              description = lib.mdDoc "Overrides the default path to the dynamic motd.";
            };
            MOTD_PATH = mkOption {
              type = types.nullOr (types.oneOf [ types.string types.path ]);
              default = defaultConfig.MOTD_PATH;
              description = lib.mdDoc "Overrides the default path to the static motd.";
            };
            FG_COLOR = mkOption {
              type = types.nullOr (types.enum availableColors);
              default = defaultConfig.FG_COLOR;
              description = lib.mdDoc "Foreground color, available only in daemon mode.";
            };
            BG_COLOR = mkOption {
              type = types.nullOr (types.enum availableColors);
              default = defaultConfig.BG_COLOR;
              description = lib.mdDoc "Background color, available only in daemon mode.";
            };
            ENABLE_NUMLOCK = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.ENABLE_NUMLOCK;
              description = lib.mdDoc "Enables numlock in daemon mode.";
            };
            DISPLAY_START_SCRIPT = mkOption {
              type = types.nullOr (types.oneOf [ types.string types.path ]);
              default = defaultConfig.DISPLAY_START_SCRIPT;
              description = lib.mdDoc "Script started before Display (Xorg/Wayland) starts. **NOTE:** The script is started as default user; in daemon mode it means ``root``.";
            };
            DISPLAY_STOP_SCRIPT = mkOption {
              type = types.nullOr (types.oneOf [ types.string types.path ]);
              default = defaultConfig.DISPLAY_STOP_SCRIPT;
              description = lib.mdDoc "Script started after Display (Xorg/Wayland) stops. **NOTE:** The script is started as default user; in daemon mode it means ``root``.";
            };
            SESSION_ERROR_LOGGING = mkOption {
              type = types.nullOr (types.enum [ "default" "appending" "disabled" ]);
              default = defaultConfig.SESSION_ERROR_LOGGING;
              description = lib.mdDoc "Defines how the logging of session errors handled. Possible values are \"default\", \"appending\" or \"disabled\".";
            };
            SESSION_ERROR_LOGGING_FILE = mkOption {
              type = types.nullOr (types.oneOf [ types.path types.string ]);
              default = defaultConfig.SESSION_ERROR_LOGGING_FILE;
              description = lib.mdDoc "Overrides path of session errors log file.";
              example = "/var/log/emptty/session-errors.$\{TTY_NUMBER}.log";
            };
            DEFAULT_XAUTHORITY = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.DEFAULT_XAUTHORITY;
              description =
                lib.mdDoc
                  "If set true, it will not use `.emptty-xauth` file, but the standard `~/.Xauthority` file. This allows to handle xauth issues.";
            };
            ROOTLESS_XORG = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.ROOTLESS_XORG;
              description = lib.mdDoc "If true, and emptty is running in daemon mode, Xorg will be started in rootless mode (provided the system allows it).";
            };
            IDENTIFY_ENVS = mkOption {
              type = types.bool;
              default = defaultConfig.IDENTIFY_ENVS;
              description = lib.mdDoc "If set true, environmental groups are printed to differ Xorg/Wayland/Custom/UserCustom desktops.";
            };
            HIDE_ENTER_LOGIN = mkOption {
              type = types.bool;
              default = defaultConfig.HIDE_ENTER_LOGIN;
              description = lib.mdDoc "If set true, \"hostname login:\" is not displayed. ";
            };
            HIDE_ENTER_PASSWORD = mkOption {
              type = types.bool;
              default = defaultConfig.HIDE_ENTER_PASSWORD;
              description = lib.mdDoc "If set true, \"Password:\" is not displayed. ";
            };
          };
        };
      };
    };
  };

  config =
    let
      # package needs to use the system path so it can invoke WMs and the Xorg server
      package = cfg.package.override { systemPath = config.system.path; };
    in
    mkIf cfg.enable {
      # symlink configuration for use by the program. could also be done in serviceConfig
      environment.etc."emptty/conf".text = builtins.concatStringsSep "\n" (optionsToString (cfg.configuration
        // {
        XORG_ARGS = config.services.xserver.displayManager.xserverArgs;
        XORG_SESSIONS_PATH = "${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions/";
        WAYLAND_SESSIONS_PATH = "${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions/";
      }));

      # emptty should be the only thing running on the TTYs
      systemd.services."autovt@${builtins.toString cfg.configuration.TTY_NUMBER}".enable = false;
      systemd.services."getty@tty${builtins.toString cfg.configuration.TTY_NUMBER}".enable = false;

      # most other display manager modules enable these
      security.polkit.enable = true;
      services.dbus.enable = true;

      systemd.services.emptty = {
        unitConfig = {
          Wants = [
            "systemd-user-sessions.service"
          ];
          After = [
            "systemd-user-sessions.service"
            "plymouth-quit-wait.service"
            "getty@tty${builtins.toString cfg.configuration.TTY_NUMBER}.service"
          ];
          Conflicts = [
            "getty@tty${builtins.toString cfg.configuration.TTY_NUMBER}.service"
          ];
        };

        serviceConfig = {
          # this does have the --config option, but I'm choosing to symlink it to
          # /etc/emptty/conf for easier discoverability by new users
          ExecStart = "${package}/bin/emptty -d";

          Restart = mkIf cfg.restart "always";

          # Defaults from emptty upstream configuration
          EnvironmentFile = "/etc/emptty/conf";
          Type = "idle";
          TTYPath = "/dev/tty${builtins.toString cfg.configuration.TTY_NUMBER}";
          TTYReset = "yes";
          KillMode = "process";
          IgnoreSIGPIPE = "no";
          SendSIGHUP = "yes";
        };

        # Don't kill a user session when using nixos-rebuild
        restartIfChanged = false;

        wantedBy = [ "graphical.target" ];
      };
      systemd.services.emptty.enable = true;
      systemd.defaultUnit = "graphical.target";

      security.pam.services.emptty = {
        allowNullPassword = true;
        startSession = true;
        text = ''
          auth            sufficient      pam_succeed_if.so user ingroup nopasswdlogin
          auth            include         login
          -auth           optional        pam_gnome_keyring.so
          -auth           optional        pam_kwallet5.so
          account         include         login
          password        include         login
          session         include         login
          -session        optional        pam_gnome_keyring.so auto_start
          -session        optional        pam_kwallet5.so auto_start force_run
        '';
      };

      # disable lightdm, the default DM
      services.xserver.displayManager.lightdm.enable = false;

      # rotate emptty logs, if logrotate is enabled
      services.logrotate.settings = {
        "/var/log/emptty" = mapAttrs (_: mkDefault) {
          frequency = "monthly";
          rotate = 1;
          create = "0660 root ${config.users.groups.utmp.name}";
          minsize = "1M";
        };
      };
    };
}
