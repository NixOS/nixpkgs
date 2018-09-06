{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.displayManager;
  gdm = pkgs.gnome3.gdm;

in

{

  ###### interface

  options = {

    services.xserver.displayManager.gdm = {

      enable = mkEnableOption ''
        GDM as the display manager.
        <emphasis>GDM in NixOS is not well-tested with desktops other
        than GNOME, so use with caution, as it could render the
        system unusable.</emphasis>
      '';

      debug = mkEnableOption ''
        debugging messages in GDM
      '';

      autoLogin = mkOption {
        default = {};
        description = ''
          Auto login configuration attrset.
        '';

        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Automatically log in as the sepecified <option>autoLogin.user</option>.
              '';
            };

            user = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                User to be used for the autologin.
              '';
            };

            delay = mkOption {
              type = types.int;
              default = 0;
              description = ''
                Seconds of inactivity after which the autologin will be performed.
              '';
            };

          };
        };
      };

      wayland = mkOption {
        default = true;
        description = ''
          Allow GDM run on Wayland instead of Xserver
        '';
        type = types.bool;
      };

    };

  };


  ###### implementation

  config = mkIf cfg.gdm.enable {

    assertions = [
      { assertion = cfg.gdm.autoLogin.enable -> cfg.gdm.autoLogin.user != null;
        message = "GDM auto-login requires services.xserver.displayManager.gdm.autoLogin.user to be set";
      }
    ];

    services.xserver.displayManager.lightdm.enable = false;

    users.users.gdm =
      { name = "gdm";
        uid = config.ids.uids.gdm;
        group = "gdm";
        home = "/run/gdm";
        description = "GDM user";
      };

    users.groups.gdm.gid = config.ids.gids.gdm;

    # GDM needs different xserverArgs, presumable because using wayland by default.
    services.xserver.tty = null;
    services.xserver.display = null;
    services.xserver.verbose = null;

    services.xserver.displayManager.job =
      {
        environment = {
          GDM_X_SERVER_EXTRA_ARGS = toString
            (filter (arg: arg != "-terminate") cfg.xserverArgs);
          GDM_SESSIONS_DIR = "${cfg.session.desktops}/share/xsessions";
          # Find the mouse
          XCURSOR_PATH = "~/.icons:${pkgs.gnome3.adwaita-icon-theme}/share/icons";
        };
        execCmd = "exec ${gdm}/bin/gdm";
      };

    # Because sd_login_monitor_new requires /run/systemd/machines
    systemd.services.display-manager.wants = [ "systemd-machined.service" ];
    systemd.services.display-manager.after = [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
    ];

    systemd.services.display-manager.serviceConfig = {
      # Restart = "always"; - already defined in xserver.nix
      KillMode = "mixed";
      IgnoreSIGPIPE = "no";
      BusName = "org.gnome.DisplayManager";
      StandardOutput = "syslog";
      StandardError = "inherit";
    };

    systemd.services.display-manager.path = [ pkgs.gnome3.gnome-session ];

    # Allow choosing an user account
    services.accounts-daemon.enable = true;

    services.dbus.packages = [ gdm ];

    systemd.user.services.dbus.wantedBy = [ "default.target" ];

    programs.dconf.profiles.gdm = "${gdm}/share/dconf/profile/gdm";

    # Use AutomaticLogin if delay is zero, because it's immediate.
    # Otherwise with TimedLogin with zero seconds the prompt is still
    # presented and there's a little delay.
    environment.etc."gdm/custom.conf".text = ''
      [daemon]
      WaylandEnable=${if cfg.gdm.wayland then "true" else "false"}
      ${optionalString cfg.gdm.autoLogin.enable (
        if cfg.gdm.autoLogin.delay > 0 then ''
          TimedLoginEnable=true
          TimedLogin=${cfg.gdm.autoLogin.user}
          TimedLoginDelay=${toString cfg.gdm.autoLogin.delay}
        '' else ''
          AutomaticLoginEnable=true
          AutomaticLogin=${cfg.gdm.autoLogin.user}
        '')
      }

      [security]

      [xdmcp]

      [greeter]

      [chooser]

      [debug]
      ${optionalString cfg.gdm.debug "Enable=true"}
    '';

    environment.etc."gdm/Xsession".source = config.services.xserver.displayManager.session.wrapper;

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
        auth     required       pam_env.so envfile=${config.system.build.pamEnvironment}

        auth     required       pam_succeed_if.so uid >= 1000 quiet
        auth     optional       ${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so
        auth     ${if config.security.pam.enableEcryptfs then "required" else "sufficient"} pam_unix.so nullok likeauth
        ${optionalString config.security.pam.enableEcryptfs
          "auth required ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so unwrap"}

        ${optionalString (! config.security.pam.enableEcryptfs)
          "auth     required       pam_deny.so"}

        account  sufficient     pam_unix.so

        password requisite      pam_unix.so nullok sha512
        ${optionalString config.security.pam.enableEcryptfs
          "password optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"}

        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  required       pam_unix.so
        ${optionalString config.security.pam.enableEcryptfs
          "session optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"}
        session  required       pam_loginuid.so
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       ${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';

      gdm-password.text = ''
        auth     requisite      pam_nologin.so
        auth     required       pam_env.so envfile=${config.system.build.pamEnvironment}

        auth     required       pam_succeed_if.so uid >= 1000 quiet
        auth     optional       ${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so
        auth     ${if config.security.pam.enableEcryptfs then "required" else "sufficient"} pam_unix.so nullok likeauth
        ${optionalString config.security.pam.enableEcryptfs
          "auth required ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so unwrap"}
        ${optionalString (! config.security.pam.enableEcryptfs)
          "auth     required       pam_deny.so"}

        account  sufficient     pam_unix.so

        password requisite      pam_unix.so nullok sha512
        ${optionalString config.security.pam.enableEcryptfs
          "password optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"}

        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  required       pam_unix.so
        ${optionalString config.security.pam.enableEcryptfs
          "session optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"}
        session  required       pam_loginuid.so
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       ${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
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
