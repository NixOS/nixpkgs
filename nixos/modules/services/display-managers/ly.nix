{ config, lib, pkgs, ... }:

let
  dmcfg = config.services.xserver.displayManager;
  cfg = config.services.displayManager.ly;
  xEnv = config.systemd.services.display-manager.environment;

  ly = cfg.package;

  iniFmt = pkgs.formats.iniWithGlobalSection { };

  inherit (lib)
    concatMapStrings
    attrNames getAttr
    mkIf mkOption mkEnableOption mkPackageOption
  ;

  xserverWrapper = pkgs.writeShellScript "xserver-wrapper" ''
    ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}
    exec systemd-cat -t xserver-wrapper ${dmcfg.xserverBin} ${toString dmcfg.xserverArgs} "$@"
  '';

  # Because configator used by ly has a line length limitation during parsing
  # the config file, a wrapper collects all paths linked into
  # /run/current-system/sw to reduce the path length.
  ly-data-wrapper = pkgs.linkFarm "ly-data-wrapper" {
    "bin/xauth" = "${pkgs.xorg.xauth}/bin/xauth";
    "bin/ly-xserver" = xserverWrapper;
    "share/ly" = "${dmcfg.sessionData.desktops}/share";
    "bin/ly-session" = dmcfg.sessionData.wrapper;
  };

  defaultConfig = {
      shutdown_cmd = "/run/current-system/systemd/bin/systemctl poweroff";
      restart_cmd = "/run/current-system/systemd/bin/systemctl reboot";
      tty = 2;
      service_name = "ly";
      path = "/run/current-system/sw/bin";
      term_reset_cmd = "tput reset";
      mcookie_cmd = "/run/current-system/sw/bin/mcookie";
      waylandsessions = "/run/current-system/sw/share/ly/wayland-sessions";
      wayland_cmd = "/run/current-system/sw/bin/ly-session";
      xsessions = "/run/current-system/sw/share/ly/xsessions";
      xauth_cmd = "/run/current-system/sw/bin/xauth";
      x_cmd = "/run/current-system/sw/bin/ly-xserver";
      x_cmd_setup = "/run/current-system/sw/bin/ly-session";
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
        type = with lib.types; attrsOf (oneOf [ str int bool ]);
        default = { };
        example = {
          load = false;
          save = false;
        };
        description = lib.mdDoc ''
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
    };

    environment = {
      etc."ly/config.ini".source = cfgFile;
      systemPackages = [ ly ly-data-wrapper ];
      pathsToLink = [ "/share/ly" ];
    };

    services = {
      dbus.packages = [ ly ];
      xserver = {
        displayManager.job.execCmd = "exec /run/current-system/sw/bin/ly";
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

        conflicts = [
          "getty@tty7.service"
        ];

        serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          TTYPath = "/dev/tty${toString finalConfig.tty}";
          TTYReset = "yes";
          TTYHangup = "yes";
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ vonfry ];
}
