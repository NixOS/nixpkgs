{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.displayManager.gdm;
  gdm = pkgs.gdm;
  xdmcfg = config.services.xserver.displayManager;
  pamLogin = config.security.pam.services.login;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "custom.conf" cfg.settings;

  xSessionWrapper =
    if (xdmcfg.setupCommands == "") then
      null
    else
      pkgs.writeScript "gdm-x-session-wrapper" ''
        #!${pkgs.bash}/bin/bash
        ${xdmcfg.setupCommands}
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
    load-module module-always-sink
    load-module module-intended-roles
    load-module module-suspend-on-idle
    load-module module-position-event-sounds
  '';

  defaultSessionName = config.services.displayManager.defaultSession;

  setSessionScript = pkgs.callPackage ../x11/display-managers/account-service-util.nix { };
in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "autoLogin" "enable" ]
      [
        "services"
        "displayManager"
        "autoLogin"
        "enable"
      ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "autoLogin" "user" ]
      [
        "services"
        "displayManager"
        "autoLogin"
        "user"
      ]
    )

    (lib.mkRemovedOptionModule [
      "services"
      "xserver"
      "displayManager"
      "gdm"
      "nvidiaWayland"
    ] "We defer to GDM whether Wayland should be enabled.")

    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "enable" ]
      [ "services" "displayManager" "gdm" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "debug" ]
      [ "services" "displayManager" "gdm" "debug" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "banner" ]
      [ "services" "displayManager" "gdm" "banner" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "settings" ]
      [ "services" "displayManager" "gdm" "settings" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "wayland" ]
      [ "services" "displayManager" "gdm" "wayland" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "autoSuspend" ]
      [ "services" "displayManager" "gdm" "autoSuspend" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "gdm" "autoLogin" "delay" ]
      [ "services" "displayManager" "gdm" "autoLogin" "delay" ]
    )
  ];

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.displayManager.gdm = {

      enable = lib.mkEnableOption "GDM, the GNOME Display Manager";

      debug = lib.mkEnableOption "debugging messages in GDM";

      # Auto login options specific to GDM
      autoLogin.delay = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Seconds of inactivity after which the autologin will be performed.
        '';
      };

      wayland = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Allow GDM to run on Wayland instead of Xserver.
        '';
      };

      autoSuspend = lib.mkOption {
        default = true;
        description = ''
          On the GNOME Display Manager login screen, suspend the machine after inactivity.
          (Does not affect automatic suspend while logged in, or at lock screen.)
        '';
        type = lib.types.bool;
      };

      banner = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        example = ''
          foo
          bar
          baz
        '';
        description = ''
          Optional message to display on the login screen.
        '';
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        example = {
          debug.enable = true;
        };
        description = ''
          Options passed to the gdm daemon.
          See [here](https://help.gnome.org/admin/gdm/stable/configuration.html.en#daemonconfig) for supported options.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.xserver.displayManager.lightdm.enable = false;

    users.users.gdm = {
      name = "gdm";
      uid = config.ids.uids.gdm;
      group = "gdm";
      home = "/run/gdm";
      description = "GDM user";
    };

    users.groups.gdm.gid = config.ids.gids.gdm;

    # GDM needs different xserverArgs, presumable because using wayland by default.
    services.xserver.display = null;
    services.xserver.verbose = null;

    services.displayManager = {
      # Enable desktop session data
      enable = true;

      environment = {
        GDM_X_SERVER_EXTRA_ARGS = toString (lib.filter (arg: arg != "-terminate") xdmcfg.xserverArgs);
        XDG_DATA_DIRS = lib.makeSearchPath "share" [
          gdm # for gnome-login.session
          config.services.displayManager.sessionData.desktops
          pkgs.gnome-control-center # for accessibility icon
          pkgs.adwaita-icon-theme
          pkgs.hicolor-icon-theme # empty icon theme as a base
        ];
      }
      // lib.optionalAttrs (xSessionWrapper != null) {
        # Make GDM use this wrapper before running the session, which runs the
        # configured setupCommands. This relies on a patched GDM which supports
        # this environment variable.
        GDM_X_SESSION_WRAPPER = "${xSessionWrapper}";
      };
      execCmd = "exec ${gdm}/bin/gdm";
      preStart = lib.optionalString (defaultSessionName != null) ''
        # Set default session in session chooser to a specified values – basically ignore session history.
        ${setSessionScript}/bin/set-session ${config.services.displayManager.sessionData.autologinSession}
      '';
    };

    systemd.tmpfiles.rules = [
      "d /run/gdm/.config 0711 gdm gdm"
    ]
    ++ lib.optionals config.services.pulseaudio.enable [
      "d /run/gdm/.config/pulse 0711 gdm gdm"
      "L+ /run/gdm/.config/pulse/${pulseConfig.name} - - - - ${pulseConfig}"
    ]
    ++ lib.optionals config.services.gnome.gnome-initial-setup.enable [
      # Create stamp file for gnome-initial-setup to prevent it starting in GDM.
      "f /run/gdm/.config/gnome-initial-setup-done 0711 gdm gdm - yes"
    ];

    # Otherwise GDM will not be able to start correctly and display Wayland sessions
    systemd.packages = [
      gdm
      pkgs.gnome-session
      pkgs.gnome-shell
    ];
    environment.systemPackages = [
      pkgs.adwaita-icon-theme
      pkgs.gdm # For polkit rules
    ];

    # We dont use the upstream gdm service
    # it has to be disabled since the gdm package has it
    # https://github.com/NixOS/nixpkgs/issues/108672
    systemd.services.gdm.enable = false;

    systemd.services.display-manager.wants = [
      # Because sd_login_monitor_new requires /run/systemd/machines
      "systemd-machined.service"
      # setSessionScript wants AccountsService
      "accounts-daemon.service"
    ];

    systemd.services.display-manager.after = [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "plymouth-quit.service"
      "plymouth-start.service"
    ];
    systemd.services.display-manager.conflicts = [
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
    systemd.services.plymouth-quit = lib.mkIf config.boot.plymouth.enable {
      wantedBy = lib.mkForce [ ];
    };

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

    systemd.services.display-manager.path = [ pkgs.gnome-session ];

    # Allow choosing an user account
    services.accounts-daemon.enable = true;

    services.dbus.packages = [ gdm ];

    systemd.user.services.dbus.wantedBy = [ "default.target" ];

    programs.dconf.profiles.gdm.databases =
      lib.optionals (!cfg.autoSuspend) [
        {
          settings."org/gnome/settings-daemon/plugins/power" = {
            sleep-inactive-ac-type = "nothing";
            sleep-inactive-battery-type = "nothing";
            sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
            sleep-inactive-battery-timeout = lib.gvariant.mkInt32 0;
          };
        }
      ]
      ++ lib.optionals (cfg.banner != null) [
        {
          settings."org/gnome/login-screen" = {
            banner-message-enable = true;
            banner-message-text = cfg.banner;
          };
        }
      ]
      ++ [ "${gdm}/share/gdm/greeter-dconf-defaults" ];

    # Use AutomaticLogin if delay is zero, because it's immediate.
    # Otherwise with TimedLogin with zero seconds the prompt is still
    # presented and there's a little delay.
    services.displayManager.gdm.settings = {
      daemon = lib.mkMerge [
        { WaylandEnable = cfg.wayland; }
        # nested if else didn't work
        (lib.mkIf (config.services.displayManager.autoLogin.enable && cfg.autoLogin.delay != 0) {
          TimedLoginEnable = true;
          TimedLogin = config.services.displayManager.autoLogin.user;
          TimedLoginDelay = cfg.autoLogin.delay;
        })
        (lib.mkIf (config.services.displayManager.autoLogin.enable && cfg.autoLogin.delay == 0) {
          AutomaticLoginEnable = true;
          AutomaticLogin = config.services.displayManager.autoLogin.user;
        })
      ];
      debug = lib.mkIf cfg.debug {
        Enable = true;
      };
    };

    environment.etc."gdm/custom.conf".source = configFile;

    environment.etc."gdm/Xsession".source = config.services.displayManager.sessionData.wrapper;

    # GDM LFS PAM modules, adapted somehow to NixOS
    security.pam.services = {
      gdm-launch-environment.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = gdm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = gdm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = gdm
        session  required       pam_env.so conffile=/etc/pam/environment readenv=0
        session  optional       ${config.systemd.package}/lib/security/pam_systemd.so
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
        ${lib.optionalString (pamLogin.enable && pamLogin.enableGnomeKeyring) ''
          auth       [success=ok default=1]      ${gdm}/lib/security/pam_gdm.so
          auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
        ''}
        auth      required      pam_permit.so

        account   sufficient    pam_unix.so

        password  requisite     pam_unix.so nullok yescrypt

        session   optional      pam_keyinit.so revoke
        session   include       login
      '';

      # This would block password prompt when included by gdm-password.
      # GDM will instead run gdm-fingerprint in parallel.
      login.fprintAuth = lib.mkIf config.services.fprintd.enable false;

      gdm-fingerprint.text = lib.mkIf config.services.fprintd.enable ''
        auth       required                    pam_shells.so
        auth       requisite                   pam_nologin.so
        auth       requisite                   pam_faillock.so      preauth
        auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
        auth       required                    pam_env.so conffile=/etc/pam/environment readenv=0
        ${lib.optionalString (pamLogin.enable && pamLogin.enableGnomeKeyring) ''
          auth       [success=ok default=1]      ${gdm}/lib/security/pam_gdm.so
          auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
        ''}

        account    include                     login

        password   required                    pam_deny.so

        session    include                     login
      '';
    };

  };

}
