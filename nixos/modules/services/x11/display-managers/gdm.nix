{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.displayManager;
  gdm = pkgs.gnome3_12.gdm; # gdm 3.10 not supported
  gnome3 = config.environment.gnome3.packageSet;

in

{

  ###### interface

  options = {

    services.xserver.displayManager.gdm = {

      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to enable GDM as the display manager.
          <emphasis>GDM is very experimental and may render system unusable.</emphasis>
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.gdm.enable {

    services.xserver.displayManager.slim.enable = false;

    users.extraUsers.gdm =
      { name = "gdm";
        uid = config.ids.uids.gdm;
        group = "gdm";
        home = "/run/gdm";
        description = "GDM user";
      };

    users.extraGroups.gdm.gid = config.ids.gids.gdm;

    services.xserver.displayManager.job =
      { 
        environment = {
          GDM_X_SERVER = "${cfg.xserverBin} ${cfg.xserverArgs}";
          GDM_SESSIONS_DIR = "${cfg.session.desktops}";
          XDG_CONFIG_DIRS = "${gnome3.gnome_settings_daemon}/etc/xdg";
        };
        execCmd = "exec ${gdm}/sbin/gdm";
      };

    # Because sd_login_monitor_new requires /run/systemd/machines
    systemd.services.display-manager.wants = [ "systemd-machined.service" ];
    systemd.services.display-manager.after = [ "systemd-machined.service" ];

    systemd.services.display-manager.path = [ gnome3.gnome_shell gnome3.caribou ];

    services.dbus.packages = [ gdm ];

    programs.dconf.profiles.gdm = "${gdm}/share/dconf/profile/gdm";

    # GDM LFS PAM modules, adapted somehow to NixOS
    security.pam.services = {
      gdm-launch-environment.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = gdm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = gdm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = gdm
        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so
      '';

     gdm.text = ''
        auth     requisite      pam_nologin.so
        auth     required       pam_env.so

        auth     required       pam_succeed_if.so uid >= 1000 quiet
        auth     optional       ${gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
        auth     sufficient     pam_unix.so nullok likeauth
        auth     required       pam_deny.so

        account  sufficient     pam_unix.so

        password requisite      pam_unix.so nullok sha512

        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  required       pam_unix.so
        session  required       pam_loginuid.so
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       ${gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';

      gdm-password.text = ''
        auth     requisite      pam_nologin.so
        auth     required       pam_env.so envfile=${config.system.build.pamEnvironment}

        auth     required       pam_succeed_if.so uid >= 1000 quiet
        auth     optional       ${gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
        auth     sufficient     pam_unix.so nullok likeauth
        auth     required       pam_deny.so 

        account  sufficient     pam_unix.so
        
        password requisite      pam_unix.so nullok sha512

        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  required       pam_unix.so
        session  required       pam_loginuid.so
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       ${gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';

      gdm-autologin.text = ''
        auth     requisite      pam_nologin.so

        auth     required       pam_succeed_if.so uid >= 1000 quiet
        auth     required       pam_permit.so

        account  sufficient     pam_unix.so

        password requisite      pam_unix.so nullok sha512

        session  optional       pam_keyinit.so revoke
        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  required       pam_unix.so
        session  required       pam_loginuid.so
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
      '';

    };

  };

}
