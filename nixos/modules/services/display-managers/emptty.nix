{
  config,
  pkgs,
  lib,
  ...
}:
let
  dmcfg = config.services.displayManager;
  cfg = config.services.displayManager.emptty;
  desktops = config.services.displayManager.sessionData.desktops;

  emptty = cfg.package.override { x11Support = cfg.x11Support; };

  settingsFormat = pkgs.formats.keyValue { };
in
{
  options = {
    services.displayManager.emptty = {
      enable = lib.mkEnableOption "emptty as the display manager";
      x11Support = lib.mkOption {
        description = "Whether to enable support for X11";
        type = lib.types.bool;
        default = config.services.xserver.enable;
        defaultText = "services.xserver.enable";
      };

      package = lib.mkPackageOption pkgs "emptty" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
        default = { };
        description = ''
          Configuration for emptty, provided as a Nix attribute set and automatically
          serialized to simple key-value pair.
          See [emptty configuration documentation](https://github.com/tvrzna/emptty/blob/master/README.md) for available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = dmcfg.autoLogin.enable -> dmcfg.sessionData.autologinSession != null;
        message = ''
          emptty auto-login requires that services.displayManager.defaultSession is set.
        '';
      }
    ];

    security.pam.services = {
      emptty = {
        unixAuth = true;
        startSession = true;
        enableGnomeKeyring = lib.mkDefault config.services.gnome.gnome-keyring.enable;
        rules.auth.autologin = {
          enable = dmcfg.autoLogin.enable;
          order = config.security.pam.services.emptty.rules.auth.unix.order - 10;
          control = "sufficient";
          modulePath = "${config.security.pam.package}/lib/security/pam_succeed_if.so";
          settings.quiet = true;
          args = [
            "user"
            "="
            dmcfg.autoLogin.user
          ];
        };
      };
    };

    environment.systemPackages = [ emptty ];

    services = {
      dbus.packages = [ emptty ];
      xserver = {
        display = null;
      };
      displayManager = {
        enable = true;
        generic = {
          enable = true;
          execCmd = "exec ${lib.getExe emptty} --daemon --config ${settingsFormat.generate "config" cfg.settings}";
        };
        emptty = {
          settings = {
            TTY_NUMBER = 1;
            SWITCH_TTY = lib.mkDefault true;
            AUTO_SELECTION = lib.mkDefault true;
            XORG_ARGS = toString config.services.xserver.displayManager.xserverArgs;
            XORG_SESSIONS_PATH = "${desktops}/share/xsessions";
            WAYLAND_SESSIONS_PATH = "${desktops}/share/wayland-sessions";
          }
          // lib.optionalAttrs (dmcfg.defaultSession != null) {
            DEFAULT_SESSION = dmcfg.defaultSession;
          }
          // lib.optionalAttrs dmcfg.autoLogin.enable {
            AUTOLOGIN = true;
            DEFAULT_USER = dmcfg.autoLogin.user;
            AUTOLOGIN_SESSION = dmcfg.sessionData.autologinSession;
          };
        };
      };
    };

    systemd.services.display-manager = {
      path = [ "/run/current-system/sw" ];
      unitConfig = {
        Wants = [ "systemd-user-sessions.service" ];
        After = [
          "systemd-user-sessions.service"
          "plymouth-quit-wait.service"
        ];
      };
      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        TTYPath = "/dev/tty${toString cfg.settings.TTY_NUMBER or 1}";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = true;
        KillMode = "process";
        IgnoreSIGPIPE = "no";
        SendSIGHUP = "yes";
        LogDirectory = "emptty";
        CacheDirectory = "emptty";
      };
      restartIfChanged = false;
    };
  };
}
