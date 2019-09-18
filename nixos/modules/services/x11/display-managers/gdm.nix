{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.displayManager;
  gdm = pkgs.gnome3.gdm;

  xSessionWrapper = if (cfg.setupCommands == "") then null else
    pkgs.writeScript "gdm-x-session-wrapper" ''
      #!${pkgs.bash}/bin/bash
      ${cfg.setupCommands}
      exec "$@"
    '';

  # Solves problems like:
  # https://wiki.archlinux.org/index.php/Talk:Bluetooth_headset#GDMs_pulseaudio_instance_captures_bluetooth_headset
  # Instead of blacklisting plugins, we use Fedora's PulseAudio configuration for GDM:
  # https://src.fedoraproject.org/rpms/gdm/blob/master/f/default.pa-for-gdm
  pulseConfig = pkgs.writeText "default.pa" ''
    load-module module-device-restore
    load-module module-card-restore
    load-module module-udev-detect
    load-module module-native-protocol-unix
    load-module module-default-device-restore
    load-module module-rescue-streams
    load-module module-always-sink
    load-module module-intended-roles
    load-module module-suspend-on-idle
    load-module module-position-event-sounds
  '';

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

      autoSuspend = mkOption {
        default = true;
        description = ''
          Suspend the machine after inactivity.
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
          XDG_DATA_DIRS = "${cfg.session.desktops}/share/";
        } // optionalAttrs (xSessionWrapper != null) {
          # Make GDM use this wrapper before running the session, which runs the
          # configured setupCommands. This relies on a patched GDM which supports
          # this environment variable.
          GDM_X_SESSION_WRAPPER = "${xSessionWrapper}";
        };
        execCmd = "exec ${gdm}/bin/gdm";
        preStart = optionalString config.hardware.pulseaudio.enable ''
          mkdir -p /run/gdm/.config/pulse
          ln -sf ${pulseConfig} /run/gdm/.config/pulse/default.pa
          chown -R gdm:gdm /run/gdm/.config
        '';
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

    programs.dconf.profiles.gdm =
    let
      customDconf = pkgs.writeTextFile {
        name = "gdm-dconf";
        destination = "/dconf/gdm-custom";
        text = ''
          ${optionalString (!cfg.gdm.autoSuspend) ''
            [org/gnome/settings-daemon/plugins/power]
            sleep-inactive-ac-type='nothing'
            sleep-inactive-battery-type='nothing'
            sleep-inactive-ac-timeout=0
            sleep-inactive-battery-timeout=0
          ''}
        '';
      };

      customDconfDb = pkgs.stdenv.mkDerivation {
        name = "gdm-dconf-db";
        buildCommand = ''
          ${pkgs.gnome3.dconf}/bin/dconf compile $out ${customDconf}/dconf
        '';
      };
    in pkgs.stdenv.mkDerivation {
      name = "dconf-gdm-profile";
      buildCommand = ''
        # Check that the GDM profile starts with what we expect.
        if [ $(head -n 1 ${gdm}/share/dconf/profile/gdm) != "user-db:user" ]; then
          echo "GDM dconf profile changed, please update gdm.nix"
          exit 1
        fi
        # Insert our custom DB behind it.
        sed '2ifile-db:${customDconfDb}' ${gdm}/share/dconf/profile/gdm > $out
      '';
    };

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
        session  required       pam_env.so conffile=${config.system.build.pamEnvironment} readenv=0
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so
      '';

      gdm-password.text = ''
        auth      substack      login
        account   include       login
        password  substack      login
        session   include       login
      '';

      gdm-autologin.text = ''
        auth      requisite     pam_nologin.so

        auth      required      pam_succeed_if.so uid >= 1000 quiet
        auth      required      pam_permit.so

        account   sufficient    pam_unix.so

        password  requisite     pam_unix.so nullok sha512

        session   optional      pam_keyinit.so revoke
        session   include       login
      '';

    };

  };

}
