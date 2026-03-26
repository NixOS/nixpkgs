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
    # Use NixOS's display-manager.service instead of upstream's plasmalogin.service.
    # The upstream unit has Alias=display-manager.service, which causes systemd to
    # establish a ConsistsOf relationship with graphical.target. When
    # switch-to-configuration restarts graphical.target, PLM gets stopped as a
    # side effect, killing the user session.
    services.displayManager = {
      enable = true;
      execCmd = "exec ${cfg.package}/bin/plasmalogin";
    };

    environment.systemPackages = [ cfg.package ];
    # Don't use systemd.packages as it imports the upstream plasmalogin.service
    systemd.tmpfiles.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    # Force enable display-manager.service (default.nix disables it when no
    # known DM like sddm/gdm is enabled)
    systemd.services.display-manager.enable = true;

    # Copy the After/Conflicts from the upstream unit and add PLM to PATH
    systemd.services.display-manager = {
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit.service"
        "systemd-logind.service"
      ];
      conflicts = [
        "getty@tty1.service"
      ];
      path = [ cfg.package ];
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
