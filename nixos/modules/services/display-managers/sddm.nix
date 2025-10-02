{
  config,
  lib,
  pkgs,
  ...
}:

let
  xcfg = config.services.xserver;
  dmcfg = config.services.displayManager;
  cfg = config.services.displayManager.sddm;
  xEnv = config.systemd.services.display-manager.environment;

  sddm = cfg.package.override (old: {
    extraPackages =
      old.extraPackages or [ ]
      ++ lib.optionals cfg.wayland.enable [ pkgs.qt6.qtwayland ]
      ++ lib.optionals (cfg.wayland.compositor == "kwin") [ pkgs.kdePackages.layer-shell-qt ]
      ++ cfg.extraPackages;
  });

  iniFmt = pkgs.formats.ini { };

  inherit (lib)
    concatMapStrings
    concatStringsSep
    getExe
    attrNames
    getAttr
    optionalAttrs
    optionalString
    mkRemovedOptionModule
    mkRenamedOptionModule
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;

  xserverWrapper = pkgs.writeShellScript "xserver-wrapper" ''
    ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}
    exec systemd-cat -t xserver-wrapper ${xcfg.displayManager.xserverBin} ${toString xcfg.displayManager.xserverArgs} "$@"
  '';

  Xsetup = pkgs.writeShellScript "Xsetup" ''
    ${cfg.setupScript}
    ${xcfg.displayManager.setupCommands}
  '';

  Xstop = pkgs.writeShellScript "Xstop" ''
    ${cfg.stopScript}
  '';

  defaultConfig = {
    General = {
      HaltCommand = "/run/current-system/systemd/bin/systemctl poweroff";
      RebootCommand = "/run/current-system/systemd/bin/systemctl reboot";
      Numlock = if cfg.autoNumlock then "on" else "none"; # on, off none

      # Implementation is done via pkgs/applications/display-managers/sddm/sddm-default-session.patch
      DefaultSession = optionalString (
        config.services.displayManager.defaultSession != null
      ) "${config.services.displayManager.defaultSession}.desktop";

      DisplayServer = if cfg.wayland.enable then "wayland" else "x11";
    }
    // optionalAttrs (cfg.wayland.enable && cfg.wayland.compositor == "kwin") {
      GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
      InputMethod = ""; # needed if we are using --inputmethod with kwin
    };

    Theme = {
      Current = cfg.theme;
      ThemeDir = "/run/current-system/sw/share/sddm/themes";
      FacesDir = "/run/current-system/sw/share/sddm/faces";
    }
    // optionalAttrs (cfg.theme == "breeze") {
      CursorTheme = "breeze_cursors";
      CursorSize = 24;
    };

    Users = {
      MaximumUid = config.ids.uids.nixbld;
      HideUsers = concatStringsSep "," dmcfg.hiddenUsers;
      HideShells = "/run/current-system/sw/bin/nologin";
    };

    Wayland = {
      EnableHiDPI = cfg.enableHidpi;
      SessionDir = "${dmcfg.sessionData.desktops}/share/wayland-sessions";
      CompositorCommand = lib.optionalString cfg.wayland.enable cfg.wayland.compositorCommand;
    };

  }
  // optionalAttrs xcfg.enable {
    X11 = {
      ServerPath = toString xserverWrapper;
      XephyrPath = "${pkgs.xorg.xorgserver.out}/bin/Xephyr";
      SessionCommand = toString dmcfg.sessionData.wrapper;
      SessionDir = "${dmcfg.sessionData.desktops}/share/xsessions";
      XauthPath = "${pkgs.xorg.xauth}/bin/xauth";
      DisplayCommand = toString Xsetup;
      DisplayStopCommand = toString Xstop;
      EnableHiDPI = cfg.enableHidpi;
    };
  }
  // optionalAttrs dmcfg.autoLogin.enable {
    Autologin = {
      User = dmcfg.autoLogin.user;
      Session = autoLoginSessionName;
      Relogin = cfg.autoLogin.relogin;
    };
  };

  cfgFile = iniFmt.generate "sddm.conf" (lib.recursiveUpdate defaultConfig cfg.settings);

  autoLoginSessionName = "${dmcfg.sessionData.autologinSession}.desktop";

  compositorCmds = {
    kwin = concatStringsSep " " [
      "${lib.getBin pkgs.kdePackages.kwin}/bin/kwin_wayland"
      "--no-global-shortcuts"
      "--no-kactivities"
      "--no-lockscreen"
      "--locale1"
    ];
    # This is basically the upstream default, but with Weston referenced by full path
    # and the configuration generated from NixOS options.
    weston =
      let
        westonIni = (pkgs.formats.ini { }).generate "weston.ini" {
          libinput = {
            enable-tap = config.services.libinput.mouse.tapping;
            left-handed = config.services.libinput.mouse.leftHanded;
          };
          keyboard = {
            keymap_model = xcfg.xkb.model;
            keymap_layout = xcfg.xkb.layout;
            keymap_variant = xcfg.xkb.variant;
            keymap_options = xcfg.xkb.options;
          };
        };
      in
      "${getExe pkgs.weston} --shell=kiosk -c ${westonIni}";
  };

in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "autoLogin" "minimumUid" ]
      [ "services" "displayManager" "sddm" "autoLogin" "minimumUid" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "autoLogin" "relogin" ]
      [ "services" "displayManager" "sddm" "autoLogin" "relogin" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "autoNumlock" ]
      [ "services" "displayManager" "sddm" "autoNumlock" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "enable" ]
      [ "services" "displayManager" "sddm" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "enableHidpi" ]
      [ "services" "displayManager" "sddm" "enableHidpi" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "extraPackages" ]
      [ "services" "displayManager" "sddm" "extraPackages" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "package" ]
      [ "services" "displayManager" "sddm" "package" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "settings" ]
      [ "services" "displayManager" "sddm" "settings" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "setupScript" ]
      [ "services" "displayManager" "sddm" "setupScript" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "stopScript" ]
      [ "services" "displayManager" "sddm" "stopScript" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "theme" ]
      [ "services" "displayManager" "sddm" "theme" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sddm" "wayland" "enable" ]
      [ "services" "displayManager" "sddm" "wayland" "enable" ]
    )

    (mkRemovedOptionModule [
      "services"
      "displayManager"
      "sddm"
      "themes"
    ] "Set the option `services.displayManager.sddm.package' instead.")
    (mkRenamedOptionModule
      [ "services" "displayManager" "sddm" "autoLogin" "enable" ]
      [ "services" "displayManager" "autoLogin" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "displayManager" "sddm" "autoLogin" "user" ]
      [ "services" "displayManager" "autoLogin" "user" ]
    )
    (mkRemovedOptionModule [
      "services"
      "displayManager"
      "sddm"
      "extraConfig"
    ] "Set the option `services.displayManager.sddm.settings' instead.")
  ];

  options = {

    services.displayManager.sddm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable sddm as the display manager.
        '';
      };

      package = mkPackageOption pkgs [ "kdePackages" "sddm" ] { };

      enableHidpi = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable automatic HiDPI mode.
        '';
      };

      settings = mkOption {
        type = iniFmt.type;
        default = { };
        example = {
          Autologin = {
            User = "john";
            Session = "plasma.desktop";
          };
        };
        description = ''
          Extra settings merged in and overwriting defaults in sddm.conf.
        '';
      };

      theme = mkOption {
        type = types.str;
        default = "";
        example = lib.literalExpression "\"\${pkgs.where-is-my-sddm-theme.override { variants = [ \"qt5\" ]; }}/share/sddm/themes/where_is_my_sddm_theme_qt5\"";
        description = ''
          Greeter theme to use.
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        defaultText = "[]";
        description = ''
          Extra Qt plugins / QML libraries to add to the environment.
        '';
      };

      autoNumlock = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable numlock at login.
        '';
      };

      setupScript = mkOption {
        type = types.str;
        default = "";
        example = ''
          # workaround for using NVIDIA Optimus without Bumblebee
          xrandr --setprovideroutputsource modesetting NVIDIA-0
          xrandr --auto
        '';
        description = ''
          A script to execute when starting the display server. DEPRECATED, please
          use {option}`services.xserver.displayManager.setupCommands`.
        '';
      };

      stopScript = mkOption {
        type = types.str;
        default = "";
        description = ''
          A script to execute when stopping the display server.
        '';
      };

      # Configuration for automatic login specific to SDDM
      autoLogin = {
        relogin = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true automatic login will kick in again on session exit (logout), otherwise it
            will only log in automatically when the display-manager is started.
          '';
        };

        minimumUid = mkOption {
          type = types.ints.u16;
          default = 1000;
          description = ''
            Minimum user ID for auto-login user.
          '';
        };
      };

      # Experimental Wayland support
      wayland = {
        enable = mkEnableOption "experimental Wayland support";

        compositor = mkOption {
          description = "The compositor to use: ${lib.concatStringsSep ", " (builtins.attrNames compositorCmds)}";
          type = types.enum (builtins.attrNames compositorCmds);
          default = "weston";
        };

        compositorCommand = mkOption {
          type = types.str;
          internal = true;
          default = compositorCmds.${cfg.wayland.compositor};
          description = "Command used to start the selected compositor";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = xcfg.enable || cfg.wayland.enable;
        message = ''
          SDDM requires either services.xserver.enable or services.displayManager.sddm.wayland.enable to be true
        '';
      }
      {
        assertion = config.services.displayManager.autoLogin.enable -> autoLoginSessionName != null;
        message = ''
          SDDM auto-login requires that services.displayManager.defaultSession is set.
        '';
      }
    ];

    services.displayManager = {
      enable = true;
      execCmd = "exec /run/current-system/sw/bin/sddm";
    };

    security.pam.services = {
      sddm.text = ''
        auth      substack      login
        account   include       login
        password  substack      login
        session   include       login
      '';

      sddm-greeter.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = sddm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = sddm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = sddm
        session  required       pam_env.so conffile=/etc/pam/environment readenv=0
        session  optional       ${config.systemd.package}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so
      '';

      sddm-autologin.text = ''
        auth     requisite pam_nologin.so
        auth     required  pam_succeed_if.so uid >= ${toString cfg.autoLogin.minimumUid} quiet
        auth     required  pam_permit.so

        account  include   sddm

        password include   sddm

        session  include   sddm
      '';
    };

    users.users.sddm = {
      createHome = true;
      home = "/var/lib/sddm";
      group = "sddm";
      uid = config.ids.uids.sddm;
    };

    environment = {
      etc."sddm.conf".source = cfgFile;
      pathsToLink = [
        "/share/sddm"
      ];
      systemPackages = [ sddm ];
    };

    users.groups.sddm.gid = config.ids.gids.sddm;

    services = {
      dbus.packages = [ sddm ];
      xserver = {
        # To enable user switching, allow sddm to allocate displays dynamically.
        display = null;
      };
    };

    systemd = {
      tmpfiles.packages = [ sddm ];

      # We're not using the upstream unit, so copy these: https://github.com/sddm/sddm/blob/develop/services/sddm.service.in
      services.display-manager = {
        after = [
          "systemd-user-sessions.service"
          "plymouth-quit.service"
          "systemd-logind.service"
        ];
      };
    };
  };
}
