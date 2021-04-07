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

  defaultSessionName = config.services.xserver.displayManager.defaultSession;

  setSessionScript = pkgs.callPackage ./account-service-util.nix { };
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "gdm" "autoLogin" "enable" ] [
      "services"
      "xserver"
      "displayManager"
      "autoLogin"
      "enable"
    ])
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "gdm" "autoLogin" "user" ] [
      "services"
      "xserver"
      "displayManager"
      "autoLogin"
      "user"
    ])
  ];

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    services.xserver.displayManager.gdm = {

      enable = mkEnableOption "GDM, the GNOME Display Manager";

      debug = mkEnableOption "debugging messages in GDM";

      # Auto login options specific to GDM
      autoLogin.delay = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Seconds of inactivity after which the autologin will be performed.
        '';
      };

      wayland = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Allow GDM to run on Wayland instead of Xserver.
          Note to enable Wayland with Nvidia you need to
          enable the <option>nvidiaWayland</option>.
        '';
      };

      nvidiaWayland = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to allow wayland to be used with the proprietary
          NVidia graphics driver.
        '';
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
          XDG_DATA_DIRS = "${cfg.sessionData.desktops}/share/";
        } // optionalAttrs (xSessionWrapper != null) {
          # Make GDM use this wrapper before running the session, which runs the
          # configured setupCommands. This relies on a patched GDM which supports
          # this environment variable.
          GDM_X_SESSION_WRAPPER = "${xSessionWrapper}";
        };
        execCmd = "exec ${gdm}/bin/gdm";
        preStart = optionalString (defaultSessionName != null) ''
          # Set default session in session chooser to a specified values – basically ignore session history.
          ${setSessionScript}/bin/set-session ${cfg.sessionData.autologinSession}
        '';
      };

    systemd.tmpfiles.rules = [
      "d /run/gdm/.config 0711 gdm gdm"
    ] ++ optionals config.hardware.pulseaudio.enable [
      "d /run/gdm/.config/pulse 0711 gdm gdm"
      "L+ /run/gdm/.config/pulse/${pulseConfig.name} - - - - ${pulseConfig}"
    ] ++ optionals config.services.gnome3.gnome-initial-setup.enable [
      # Create stamp file for gnome-initial-setup to prevent it starting in GDM.
      "f /run/gdm/.config/gnome-initial-setup-done 0711 gdm gdm - yes"
    ];

    # Otherwise GDM will not be able to start correctly and display Wayland sessions
    systemd.packages = with pkgs.gnome3; [ gdm gnome-session gnome-shell ];
    environment.systemPackages = [ pkgs.gnome3.adwaita-icon-theme ];

    systemd.services.display-manager.wants = [
      # Because sd_login_monitor_new requires /run/systemd/machines
      "systemd-machined.service"
      # setSessionScript wants AccountsService
      "accounts-daemon.service"
      # Failed to open gpu '/dev/dri/card0': GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Operation not permitted
      # https://github.com/NixOS/nixpkgs/pull/25311#issuecomment-609417621
      "systemd-udev-settle.service"
    ];

    systemd.services.display-manager.after = [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "getty@tty${gdm.initialVT}.service"
      "plymouth-quit.service"
      "plymouth-start.service"
      "systemd-udev-settle.service"
    ];
    systemd.services.display-manager.conflicts = [
      "getty@tty${gdm.initialVT}.service"
      "plymouth-quit.service"
    ];
    systemd.services.display-manager.onFailure = [
      "plymouth-quit.service"
    ];

    # Prevent nixos-rebuild switch from bringing down the graphical
    # session. (If multi-user.target wants plymouth-quit.service which
    # conflicts display-manager.service, then when nixos-rebuild
    # switch starts multi-user.target, display-manager.service is
    # stopped so plymouth-quit.service can be started.)
    systemd.services.plymouth-quit.wantedBy = lib.mkForce [];

    systemd.services.display-manager.serviceConfig = {
      # Restart = "always"; - already defined in xserver.nix
      KillMode = "mixed";
      IgnoreSIGPIPE = "no";
      BusName = "org.gnome.DisplayManager";
      StandardError = "inherit";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
      KeyringMode = "shared";
      EnvironmentFile = "-/etc/locale.conf";
    };

    systemd.services.display-manager.path = [ pkgs.gnome3.gnome-session ];

    # Allow choosing an user account
    services.accounts-daemon.enable = true;

    services.dbus.packages = [ gdm ];

    # We duplicate upstream's udev rules manually to make wayland with nvidia configurable
    services.udev.extraRules = ''
      # disable Wayland on Cirrus chipsets
      ATTR{vendor}=="0x1013", ATTR{device}=="0x00b8", ATTR{subsystem_vendor}=="0x1af4", ATTR{subsystem_device}=="0x1100", RUN+="${gdm}/libexec/gdm-disable-wayland"
      # disable Wayland on Hi1710 chipsets
      ATTR{vendor}=="0x19e5", ATTR{device}=="0x1711", RUN+="${gdm}/libexec/gdm-disable-wayland"
      ${optionalString (!cfg.gdm.nvidiaWayland) ''
        DRIVER=="nvidia", RUN+="${gdm}/libexec/gdm-disable-wayland"
      ''}
      # disable Wayland when modesetting is disabled
      IMPORT{cmdline}="nomodeset", RUN+="${gdm}/libexec/gdm-disable-wayland"
    '';

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
          ${pkgs.dconf}/bin/dconf compile $out ${customDconf}/dconf
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
      WaylandEnable=${boolToString cfg.gdm.wayland}
      ${optionalString cfg.autoLogin.enable (
        if cfg.gdm.autoLogin.delay > 0 then ''
          TimedLoginEnable=true
          TimedLogin=${cfg.autoLogin.user}
          TimedLoginDelay=${toString cfg.gdm.autoLogin.delay}
        '' else ''
          AutomaticLoginEnable=true
          AutomaticLogin=${cfg.autoLogin.user}
        '')
      }

      [security]

      [xdmcp]

      [greeter]

      [chooser]

      [debug]
      ${optionalString cfg.gdm.debug "Enable=true"}
    '';

    environment.etc."gdm/Xsession".source = config.services.xserver.displayManager.sessionData.wrapper;

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
