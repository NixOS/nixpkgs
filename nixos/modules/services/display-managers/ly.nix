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
    attrNames
    concatMapStrings
    getAttr
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    optionalAttrs
    ;

  xserverWrapper = pkgs.writeShellScript "xserver-wrapper" ''
    ${concatMapStrings (n: ''
      export ${n}="${getAttr n xEnv}"
    '') (attrNames xEnv)}
    exec systemd-cat -t xserver-wrapper ${xdmcfg.xserverBin} ${toString xdmcfg.xserverArgs} "$@"
  '';

  defaultConfig = {
    shutdown_cmd = "/run/current-system/systemd/bin/systemctl poweroff";
    restart_cmd = "/run/current-system/systemd/bin/systemctl reboot";
    service_name = "ly";
    path = "/run/current-system/sw/bin";
    term_reset_cmd = "${pkgs.ncurses}/bin/tput reset";
    term_restore_cursor_cmd = "${pkgs.ncurses}/bin/tput cnorm";
    waylandsessions = "${dmcfg.sessionData.desktops}/share/wayland-sessions";
    xsessions = "${dmcfg.sessionData.desktops}/share/xsessions";
    xauth_cmd = lib.optionalString xcfg.enable "${pkgs.xauth}/bin/xauth";
    x_cmd = lib.optionalString xcfg.enable xserverWrapper;
    setup_cmd = dmcfg.sessionData.wrapper;
    brightness_up_cmd = "${lib.getExe pkgs.brightnessctl} -q -n s +10%";
    brightness_down_cmd = "${lib.getExe pkgs.brightnessctl} -q -n s 10%-";
  }
  // optionalAttrs dmcfg.autoLogin.enable {
    auto_login_service = "ly-autologin";
    auto_login_session = dmcfg.sessionData.autologinSession;
    auto_login_user = dmcfg.autoLogin.user;
  };

  finalConfig = defaultConfig // cfg.settings;

  cfgFile = iniFmt.generate "config.ini" { globalSection = finalConfig; };

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
        type = with lib.types; attrsOf iniFmt.lib.types.atom;
        default = { };
        example = {
          load = false;
          save = false;
        };
        description = ''
          Extra settings merged in and overwriting defaults in config.ini.
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
      ly-autologin.text = ''
        auth      requisite pam_nologin.so
        auth      required  pam_succeed_if.so uid >= 1000 quiet
        auth      required  pam_permit.so

        account   include   ly

        password  include   ly

        session   include   ly
      '';
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
          TTYPath = "/dev/tty${toString finalConfig.tty}";
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
