{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  cfg = dmcfg.sddm;
  xEnv = config.systemd.services."display-manager".environment;

  sddm = pkgs.sddm.override { inherit (cfg) themes; };

  xserverWrapper = pkgs.writeScript "xserver-wrapper" ''
    #!/bin/sh
    ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}
    exec ${dmcfg.xserverBin} ${dmcfg.xserverArgs} "$@"
  '';

  Xsetup = pkgs.writeScript "Xsetup" ''
    #!/bin/sh
    ${cfg.setupScript}
  '';

  Xstop = pkgs.writeScript "Xstop" ''
    #!/bin/sh
    ${cfg.stopScript}
  '';


  cfgFile = pkgs.writeText "sddm.conf" ''
    [General]
    HaltCommand=${pkgs.systemd}/bin/systemctl poweroff
    RebootCommand=${pkgs.systemd}/bin/systemctl reboot
    ${optionalString cfg.autoNumlock ''
    Numlock=on
    ''}

    [Theme]
    Current=${cfg.theme}
    ThemeDir=${sddm}/share/sddm/themes
    FacesDir=${sddm}/share/sddm/faces

    [Users]
    MaximumUid=${toString config.ids.uids.nixbld}
    HideUsers=${concatStringsSep "," dmcfg.hiddenUsers}
    HideShells=/run/current-system/sw/bin/nologin

    [XDisplay]
    MinimumVT=${toString xcfg.tty}
    ServerPath=${xserverWrapper}
    XephyrPath=${pkgs.xorg.xorgserver.out}/bin/Xephyr
    SessionCommand=${dmcfg.session.script}
    SessionDir=${dmcfg.session.desktops}
    XauthPath=${pkgs.xorg.xauth}/bin/xauth
    DisplayCommand=${Xsetup}
    DisplayStopCommand=${Xstop}

    ${optionalString cfg.autoLogin.enable ''
    [Autologin]
    User=${cfg.autoLogin.user}
    Session=${defaultSessionName}.desktop
    Relogin=${if cfg.autoLogin.relogin then "true" else "false"}
    ''}

    ${cfg.extraConfig}
  '';

  defaultSessionName =
    let
      dm = xcfg.desktopManager.default;
      wm = xcfg.windowManager.default;
    in dm + optionalString (wm != "none") (" + " + wm);

in
{
  options = {

    services.xserver.displayManager.sddm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable sddm as the display manager.
        '';
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        example = ''
          [Autologin]
          User=john
          Session=plasma.desktop
        '';
        description = ''
          Extra lines appended to the configuration of SDDM.
        '';
      };

      theme = mkOption {
        type = types.str;
        default = "maui";
        description = ''
          Greeter theme to use.
        '';
      };

      themes = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          Extra packages providing themes.
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
          A script to execute when starting the display server.
        '';
      };

      stopScript = mkOption {
        type = types.str;
        default = "";
        description = ''
          A script to execute when stopping the display server.
        '';
      };

      autoLogin = mkOption {
        default = {};
        description = ''
          Configuration for automatic login.
        '';

        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Automatically log in as <option>autoLogin.user</option>.
              '';
            };

            user = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                User to be used for the automatic login.
              '';
            };

            relogin = mkOption {
              type = types.bool;
              default = false;
              description = ''
                If true automatic login will kick in again on session exit (logout), otherwise it
                will only log in automatically when the display-manager is started.
              '';
            };
          };
        };
      };

    };

  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.autoLogin.enable -> cfg.autoLogin.user != null;
        message = ''
          SDDM auto-login requires services.xserver.displayManager.sddm.autoLogin.user to be set
        '';
      }
      { assertion = cfg.autoLogin.enable -> elem defaultSessionName dmcfg.session.names;
        message = ''
          SDDM auto-login requires that services.xserver.desktopManager.default and
          services.xserver.windowMananger.default are set to valid values. The current
          default session: ${defaultSessionName} is not valid.
        '';
      }
    ];

    services.xserver.displayManager.slim.enable = false;

    services.xserver.displayManager.job = {
      logsXsession = true;

      execCmd = "exec ${sddm}/bin/sddm";
    };

    security.pam.services = {
      sddm = {
        allowNullPassword = true;
        startSession = true;
      };

      sddm-greeter.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = sddm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = sddm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = sddm
        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so
      '';

      sddm-autologin.text = ''
        auth     requisite pam_nologin.so
        auth     required  pam_succeed_if.so uid >= 1000 quiet
        auth     required  pam_permit.so

        account  include   sddm

        password include   sddm

        session  include   sddm
      '';
    };

    users.extraUsers.sddm = {
      createHome = true;
      home = "/var/lib/sddm";
      group = "sddm";
      uid = config.ids.uids.sddm;
    };

    environment.etc."sddm.conf".source = cfgFile;

    users.extraGroups.sddm.gid = config.ids.gids.sddm;

  };
}
