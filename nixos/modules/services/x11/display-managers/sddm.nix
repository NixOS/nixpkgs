{ config, lib, pkgs, ... }:

with lib;
let
  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  cfg = dmcfg.sddm;
  xEnv = config.systemd.services.display-manager.environment;

  sddm = pkgs.libsForQt5.sddm;

  iniFmt = pkgs.formats.ini { };

  xserverWrapper = pkgs.writeShellScript "xserver-wrapper" ''
    ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}
    exec systemd-cat -t xserver-wrapper ${dmcfg.xserverBin} ${toString dmcfg.xserverArgs} "$@"
  '';

  Xsetup = pkgs.writeShellScript "Xsetup" ''
    ${cfg.setupScript}
    ${dmcfg.setupCommands}
  '';

  Xstop = pkgs.writeShellScript "Xstop" ''
    ${cfg.stopScript}
  '';

  defaultConfig = {
    General = {
      HaltCommand = "/run/current-system/systemd/bin/systemctl poweroff";
      RebootCommand = "/run/current-system/systemd/bin/systemctl reboot";
      Numlock = if cfg.autoNumlock then "on" else "none"; # on, off none
    };

    Theme = {
      Current = cfg.theme;
      ThemeDir = "/run/current-system/sw/share/sddm/themes";
      FacesDir = "/run/current-system/sw/share/sddm/faces";
    };

    Users = {
      MaximumUid = config.ids.uids.nixbld;
      HideUsers = concatStringsSep "," dmcfg.hiddenUsers;
      HideShells = "/run/current-system/sw/bin/nologin";
    };

    X11 = {
      MinimumVT = if xcfg.tty != null then xcfg.tty else 7;
      ServerPath = toString xserverWrapper;
      XephyrPath = "${pkgs.xorg.xorgserver.out}/bin/Xephyr";
      SessionCommand = toString dmcfg.sessionData.wrapper;
      SessionDir = "${dmcfg.sessionData.desktops}/share/xsessions";
      XauthPath = "${pkgs.xorg.xauth}/bin/xauth";
      DisplayCommand = toString Xsetup;
      DisplayStopCommand = toString Xstop;
      EnableHiDPI = cfg.enableHidpi;
    };

    Wayland = {
      EnableHiDPI = cfg.enableHidpi;
      SessionDir = "${dmcfg.sessionData.desktops}/share/wayland-sessions";
    };
  } // lib.optionalAttrs dmcfg.autoLogin.enable {
    Autologin = {
      User = dmcfg.autoLogin.user;
      Session = autoLoginSessionName;
      Relogin = cfg.autoLogin.relogin;
    };
  };

  cfgFile =
    iniFmt.generate "sddm.conf" (lib.recursiveUpdate defaultConfig cfg.settings);

  autoLoginSessionName =
    "${dmcfg.sessionData.autologinSession}.desktop";

in
{
  imports = [
    (mkRemovedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "themes" ]
      "Set the option `services.xserver.displayManager.sddm.package' instead.")
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "autoLogin" "enable" ]
      [ "services" "xserver" "displayManager" "autoLogin" "enable" ])
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "autoLogin" "user" ]
      [ "services" "xserver" "displayManager" "autoLogin" "user" ])
    (mkRemovedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "extraConfig" ]
      "Set the option `services.xserver.displayManager.sddm.settings' instead.")
  ];

  options = {

    services.xserver.displayManager.sddm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable sddm as the display manager.
        '';
      };

      enableHidpi = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable automatic HiDPI mode.
        '';
      };

      settings = mkOption {
        type = iniFmt.type;
        default = { };
        example = ''
          {
            Autologin = {
              User = "john";
              Session = "plasma.desktop";
            };
          }
        '';
        description = ''
          Extra settings merged in and overwritting defaults in sddm.conf.
        '';
      };

      theme = mkOption {
        type = types.str;
        default = "";
        description = ''
          Greeter theme to use.
        '';
      };

      autoNumlock = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable numlock at login.
        '';
      };

      setupScript = mkOption {
        type = types.str;
        default = "";
        example = ''
          # workaround for using NVIDIA Optimus without Bumblebee
          xrandr --setprovideroutputsource modesetting NVIDIA-0
          xrandr --auto
        '';
        description = ''
          A script to execute when starting the display server. DEPRECATED, please
          use <option>services.xserver.displayManager.setupCommands</option>.
        '';
      };

      stopScript = mkOption {
        type = types.str;
        default = "";
        description = ''
          A script to execute when stopping the display server.
        '';
      };

      # Configuration for automatic login specific to SDDM
      autoLogin = {
        relogin = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true automatic login will kick in again on session exit (logout), otherwise it
            will only log in automatically when the display-manager is started.
          '';
        };

        minimumUid = mkOption {
          type = types.ints.u16;
          default = 1000;
          description = ''
            Minimum user ID for auto-login user.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = xcfg.enable;
        message = ''
          SDDM requires services.xserver.enable to be true
        '';
      }
      {
        assertion = dmcfg.autoLogin.enable -> autoLoginSessionName != null;
        message = ''
          SDDM auto-login requires that services.xserver.displayManager.defaultSession is set.
        '';
      }
    ];

    services.xserver.displayManager.job = {
      environment = {
        # Load themes from system environment
        QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
        QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
      };

      execCmd = "exec /run/current-system/sw/bin/sddm";
    };

    security.pam.services = {
      sddm = {
        allowNullPassword = true;
        startSession = true;
      };

      sddm-greeter.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = sddm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = sddm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = sddm
        session  required       pam_env.so conffile=${config.system.build.pamEnvironment} readenv=0
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so
      '';

      sddm-autologin.text = ''
        auth     requisite pam_nologin.so
        auth     required  pam_succeed_if.so uid >= ${toString cfg.autoLogin.minimumUid} quiet
        auth     required  pam_permit.so

        account  include   sddm

        password include   sddm

        session  include   sddm
      '';
    };

    users.users.sddm = {
      createHome = true;
      home = "/var/lib/sddm";
      group = "sddm";
      uid = config.ids.uids.sddm;
    };

    environment.etc."sddm.conf".source = cfgFile;
    environment.pathsToLink = [
      "/share/sddm"
    ];

    users.groups.sddm.gid = config.ids.gids.sddm;

    environment.systemPackages = [ sddm ];
    services.dbus.packages = [ sddm ];

    # To enable user switching, allow sddm to allocate TTYs/displays dynamically.
    services.xserver.tty = null;
    services.xserver.display = null;

    systemd.tmpfiles.rules = [
      # Prior to Qt 5.9.2, there is a QML cache invalidation bug which sometimes
      # strikes new Plasma 5 releases. If the QML cache is not invalidated, SDDM
      # will segfault without explanation. We really tore our hair out for awhile
      # before finding the bug:
      # https://bugreports.qt.io/browse/QTBUG-62302
      # We work around the problem by deleting the QML cache before startup.
      # This was supposedly fixed in Qt 5.9.2 however it has been reported with
      # 5.10 and 5.11 as well. The initial workaround was to delete the directory
      # in the Xsetup script but that doesn't do anything.
      # Instead we use tmpfiles.d to ensure it gets wiped.
      # This causes a small but perceptible delay when SDDM starts.
      "e ${config.users.users.sddm.home}/.cache - - - 0"
    ];
  };
}
