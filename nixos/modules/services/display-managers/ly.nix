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

  ly = cfg.package;

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

  defaultConfig = {
    shutdown_cmd = "/run/current-system/systemd/bin/systemctl poweroff";
    restart_cmd = "/run/current-system/systemd/bin/systemctl reboot";
    tty = 2;
    service_name = "ly";
    path = "/run/current-system/sw/bin";
    term_reset_cmd = "${pkgs.ncurses}/bin/tput reset";
    term_restore_cursor_cmd = "${pkgs.ncurses}/bin/tput cnorm";
    mcookie_cmd = "/run/current-system/sw/bin/mcookie";
    waylandsessions = "${dmcfg.sessionData.desktops}/share/wayland-sessions";
    wayland_cmd = dmcfg.sessionData.wrapper;
    xsessions = "${dmcfg.sessionData.desktops}/share/xsessions";
    xauth_cmd = lib.optionalString xcfg.enable "${pkgs.xorg.xauth}/bin/xauth";
    x_cmd = lib.optionalString xcfg.enable xserverWrapper;
    x_cmd_setup = dmcfg.sessionData.wrapper;
  };

  finalConfig = defaultConfig // cfg.settings;

  cfgFile = iniFmt.generate "config.ini" { globalSection = finalConfig; };

in
{
  options = {
    services.displayManager.ly = {
      enable = mkEnableOption "ly as the display manager";

      package = mkPackageOption pkgs [ "ly" ] { };

      settings = mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            bool
          ]);
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
      };

      xserver = {
        # To enable user switching, allow ly to allocate TTYs/displays dynamically.
        tty = null;
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
          "getty@tty${toString finalConfig.tty}.service"
        ];

        conflicts = [ "getty@tty7.service" ];

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

  meta.maintainers = with lib.maintainers; [ vonfry ];
}
