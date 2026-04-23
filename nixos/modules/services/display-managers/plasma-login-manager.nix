{
  config,
  lib,
  utils,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    optionalAttrs
    ;

  cfg = config.services.displayManager.plasma-login-manager;
  xcfg = config.services.xserver;
  dmcfg = config.services.displayManager;

  iniFmt = pkgs.formats.ini { };

  defaultConfig =
    optionalAttrs xcfg.enable {
      X11.ServerPath = xcfg.displayManager.xserverBin;
    }
    // optionalAttrs dmcfg.autoLogin.enable {
      Autologin = {
        User = dmcfg.autoLogin.user;
        Session = "${dmcfg.sessionData.autologinSession}.desktop";
      };
    };

  defaultConfigFile = iniFmt.generate "00-nixos-defaults.conf" defaultConfig;
  userConfigFile = iniFmt.generate "99-user.conf" cfg.settings;
in
{
  options.services.displayManager.plasma-login-manager = {
    enable = mkEnableOption "Plasma Login Manager";
    package = mkPackageOption pkgs [
      "kdePackages"
      "plasma-login-manager"
    ] { };

    settings = mkOption {
      type = iniFmt.type;
      default = { };
      example = {
        Users.ReuseSession = false;
      };
      description = "Additional settings for Plasma Login Manager (see `man plasmalogin.conf`)";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.enable = true;

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    systemd.services.plasmalogin = {
      aliases = [ "display-manager.service" ];
      path = [ cfg.package ];
      wantedBy = [ "graphical.target" ];
      restartIfChanged = false;
      environment.XDG_DATA_DIRS = lib.mkIf (
        dmcfg.sessionPackages != [ ]
      ) "${dmcfg.sessionData.desktops}/share";
    };

    systemd.user.services.plasma-login = {
      overrideStrategy = "asDropin";
      environment.XDG_DATA_DIRS = lib.mkIf (
        dmcfg.sessionPackages != [ ]
      ) "${dmcfg.sessionData.desktops}/share";
    };

    systemd.defaultUnit = "graphical.target";

    environment.etc."plasmalogin.conf.d/00-nixos-defaults.conf".source = defaultConfigFile;
    environment.etc."plasmalogin.conf.d/99-user.conf".source = userConfigFile;

    security.pam.services = {
      plasmalogin = {
        useDefaultRules = false;
        rules = {
          auth = utils.pam.autoOrderRules [
            {
              name = "login";
              control = "substack";
              modulePath = "login";
            }
          ];
          account = utils.pam.autoOrderRules [
            {
              name = "login";
              control = "include";
              modulePath = "login";
            }
          ];
          password = utils.pam.autoOrderRules [
            {
              name = "login";
              control = "substack";
              modulePath = "login";
            }
          ];
          session = utils.pam.autoOrderRules [
            {
              name = "login";
              control = "include";
              modulePath = "login";
            }
          ];
        };
      };

      plasmalogin-autologin = {
        useDefaultRules = false;
        rules = {
          auth = utils.pam.autoOrderRules [
            {
              name = "nologin";
              control = "requisite";
              modulePath = "pam_nologin.so";
            }
            {
              name = "permit";
              control = "required";
              modulePath = "pam_permit.so";
            }
          ];

          account = utils.pam.autoOrderRules [
            {
              name = "plasmalogin";
              control = "include";
              modulePath = "plasmalogin";
            }
          ];
          password = utils.pam.autoOrderRules [
            {
              name = "plasmalogin";
              control = "include";
              modulePath = "plasmalogin";
            }
          ];
          session = utils.pam.autoOrderRules [
            {
              name = "plasmalogin";
              control = "include";
              modulePath = "plasmalogin";
            }
          ];
        };
      };

      plasmalogin-greeter = {
        useDefaultRules = false;
        rules = {
          auth = utils.pam.autoOrderRules [
            {
              # Load environment from /etc/environment and ~/.pam_environment
              name = "env";
              control = "required";
              modulePath = "pam_env.so";
              settings.conffile = "/etc/pam/environment";
              settings.readenv = 0;
            }
            {
              # Always let the greeter start without authentication
              name = "permit";
              control = "required";
              modulePath = "pam_permit.so";
            }
          ];

          account = utils.pam.autoOrderRules [
            {
              # No action required for account management
              name = "permit";
              control = "required";
              modulePath = "pam_permit.so";
            }
          ];

          password = utils.pam.autoOrderRules [
            {
              # Can't change password
              name = "deny";
              control = "required";
              modulePath = "pam_deny.so";
            }
          ];

          session = utils.pam.autoOrderRules [
            {
              # Setup session
              name = "unix";
              control = "required";
              modulePath = "pam_unix.so";
            }
            {
              name = "systemd";
              control = "optional";
              modulePath = "${config.systemd.package}/lib/security/pam_systemd.so";
            }
          ];
        };
      };
    };

    # FIXME: use upstream sysusers
    users = {
      users.plasmalogin = {
        name = "plasmalogin";
        isSystemUser = true;
        group = "plasmalogin";
        description = "Plasma Login Manager greeter user";
        home = "/var/lib/plasmalogin";
      };
      groups.plasmalogin = { };
    };
  };
}
