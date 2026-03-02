{
  config,
  lib,
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
    };

    systemd.defaultUnit = "graphical.target";

    environment.etc."plasmalogin.conf.d/00-nixos-defaults.conf".source = defaultConfigFile;
    environment.etc."plasmalogin.conf.d/99-user.conf".source = userConfigFile;

    security.pam.services = {
      plasmalogin.text = ''
        auth      substack      login
        account   include       login
        password  substack      login
        session   include       login
      '';

      plasmalogin-autologin.text = ''
        auth     requisite pam_nologin.so
        auth     required  pam_permit.so

        account  include   plasmalogin
        password include   plasmalogin
        session  include   plasmalogin
      '';

      plasmalogin-greeter.text = ''
        # Load environment from /etc/environment and ~/.pam_environment
        auth		required pam_env.so conffile=/etc/pam/environment readenv=0

        # Always let the greeter start without authentication
        auth		required pam_permit.so

        # No action required for account management
        account		required pam_permit.so

        # Can't change password
        password	required pam_deny.so

        # Setup session
        session		required pam_unix.so
        session		optional ${config.systemd.package}/lib/security/pam_systemd.so
      '';
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
