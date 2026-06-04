{
  config,
  lib,
  utils,
  pkgs,
  ...
}:

let
  dmcfg = config.services.displayManager;
  xcfg = config.services.xserver;
  xdmcfg = xcfg.displayManager;
  cfg = config.services.displayManager.ly;
  xEnv = config.systemd.services.display-manager.environment;

  inherit (lib)
    attrNames
    concatMapStrings
    getAttr
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    optionalAttrs
    ;

  ly = cfg.package.override { x11Support = cfg.x11Support; };

  iniFmt = pkgs.formats.iniWithGlobalSection { };

  xserverWrapper = pkgs.writeShellScript "xserver-wrapper" ''
    ${concatMapStrings (n: ''
      export ${n}="${getAttr n xEnv}"
    '') (attrNames xEnv)}
    exec systemd-cat -t xserver-wrapper ${xdmcfg.xserverBin} ${toString xdmcfg.xserverArgs} "$@"
  '';

  # Internal config values
  defaultConfig = {
    path = "/run/current-system/sw/bin";
    service_name = "ly";

    tty = 1;
    shutdown_cmd = "/run/current-system/systemd/bin/systemctl poweroff";
    restart_cmd = "/run/current-system/systemd/bin/systemctl reboot";
    term_reset_cmd = "${pkgs.ncurses}/bin/tput reset";
    term_restore_cursor_cmd = "${pkgs.ncurses}/bin/tput cnorm";
    setup_cmd = dmcfg.sessionData.wrapper;
    brightness_up_cmd = "${lib.getExe pkgs.brightnessctl} -q -n s +10%";
    brightness_down_cmd = "${lib.getExe pkgs.brightnessctl} -q -n s 10%-";
    waylandsessions = "${dmcfg.sessionData.desktops}/share/wayland-sessions";
  }
  # Default config values only for x.org
  // optionalAttrs xcfg.enable {
    xsessions = "${dmcfg.sessionData.desktops}/share/xsessions";
    xauth_cmd = "${pkgs.xauth}/bin/xauth";
    x_cmd = xserverWrapper;
  }
  # Default config values only for auto-login
  // optionalAttrs dmcfg.autoLogin.enable {
    auto_login_service = "ly-autologin";
    auto_login_session = dmcfg.sessionData.autologinSession;
    auto_login_user = dmcfg.autoLogin.user;
  };

  resultingConfig = defaultConfig // cfg.settings;

  cfgFile = iniFmt.generate "config.ini" {
    globalSection = resultingConfig;
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
      settings = mkOption {
        type = lib.types.submodule {
          freeformType = lib.types.attrsOf iniFmt.lib.types.atom;

          options = {
            animation = mkOption {
              type = lib.types.str;
              default = "none";
              example = "doom";
              description = ''
                The active animation.
                Use "none" for no animation.
              '';
            };

            clock = mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "%c";
              description = ''
                Format string for clock in top right corner (see strftime specification).
                If null, the clock won't be shown.
              '';
            };

            custom_sessions = mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "/etc/ly/custom-sessions";
              description = ''
                Custom sessions directory.
                You can specify multiple directories,
                e.g. /etc/ly/custom-sessions:/run/current-system/sw/share/ly/custom-sessions
              '';
            };

            lang = mkOption {
              type = lib.types.str;
              default = "en";
              description = ''
                Active language.
                Available languages can be found in https://codeberg.org/fairyglade/ly/src/branch/master/res/lang.
              '';
            };

            save = mkOption {
              type = lib.types.bool;
              default = true;
              description = "Save the current desktop and login as defaults, and load them on startup";
            };

            clear_password = mkOption {
              type = lib.types.bool;
              default = false;
              description = "Erase password input on failure";
            };

            full_color = mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Render true colors (if supported). If false, output will be in eight-color mode.
                More details at: https://codeberg.org/fairyglade/ly/src/branch/master/res/config.ini
              '';
            };

          };

        };

        default = { };

        example = {
          animation = "colormix";
          clock = "%d/%m/%Y";
          bigclock = "en";
          bigclock_seconds = true;
        };

        description = ''
          Configuration for ly. Check https://codeberg.org/fairyglade/ly/src/branch/master/res/config.ini
          for available options and their behaviour.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = dmcfg.autoLogin.enable -> dmcfg.sessionData.autologinSession != null;
        message = ''
          ly auto-login requires that services.displayManager.defaultSession is set.
        '';
      }
    ];

    security.pam.services = {
      ly = {
        startSession = true;
        unixAuth = true;
        enableGnomeKeyring = lib.mkDefault config.services.gnome.gnome-keyring.enable;
      };
    }
    // optionalAttrs dmcfg.autoLogin.enable {
      ly-autologin = {
        useDefaultRules = false;
        rules = {
          auth = utils.pam.autoOrderRules [
            {
              name = "nologin";
              control = "requisite";
              modulePath = "${config.security.pam.package}/lib/security/pam_nologin.so";
            }
            {
              name = "ly-normal-user";
              control = "required";
              modulePath = "${config.security.pam.package}/lib/security/pam_succeed_if.so";
              settings.quiet = true;
              args = lib.mkBefore [
                "uid"
                ">="
                "1000"
              ];
            }
            {
              name = "permit";
              control = "required";
              modulePath = "${config.security.pam.package}/lib/security/pam_permit.so";
            }
          ];

          account = utils.pam.autoOrderRules [
            {
              name = "ly";
              control = "include";
              modulePath = "ly";
            }
          ];

          password = utils.pam.autoOrderRules [
            {
              name = "ly";
              control = "include";
              modulePath = "ly";
            }
          ];

          session = utils.pam.autoOrderRules [
            {
              name = "ly";
              control = "include";
              modulePath = "ly";
            }
          ];
        };
      };
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
        generic = {
          enable = true;
          execCmd = "exec /run/current-system/sw/bin/ly";
        };

        # Set this here instead of 'defaultConfig' so users get eval
        # errors when they change it.
        ly.settings.tty = 1;
      };

      # To enable user switching, allow ly to allocate displays dynamically.
      xserver.display = null;
    };

    systemd = {
      # We're not using the upstream unit, so copy these:
      # https://codeberg.org/fairyglade/ly/src/branch/master/res/ly@.service
      services.display-manager = {
        after = [
          "systemd-user-sessions.service"
          "plymouth-quit-wait.service"
        ];

        serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          TTYPath = "/dev/tty${toString resultingConfig.tty}";
          TTYReset = "yes";
          TTYVHangup = "yes";
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    vonfry
    zacharyarnaise
  ];
}
