{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  xEnv = config.systemd.services.display-manager.environment;
  cfg = dmcfg.lightdm;
  sessionData = dmcfg.sessionData;

  setSessionScript = pkgs.callPackage ./account-service-util.nix { };

  inherit (pkgs) lightdm writeScript writeText;

  # lightdm runs with clearenv(), but we need a few things in the environment for X to startup
  xserverWrapper = writeScript "xserver-wrapper"
    ''
      #! ${pkgs.bash}/bin/bash
      ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}

      display=$(echo "$@" | xargs -n 1 | grep -P ^:\\d\$ | head -n 1 | sed s/^://)
      if [ -z "$display" ]
      then additionalArgs=":0 -logfile /var/log/X.0.log"
      else additionalArgs="-logfile /var/log/X.$display.log"
      fi

      exec ${dmcfg.xserverBin} ${toString dmcfg.xserverArgs} $additionalArgs "$@"
    '';

  usersConf = writeText "users.conf"
    ''
      [UserList]
      minimum-uid=500
      hidden-users=${concatStringsSep " " dmcfg.hiddenUsers}
      hidden-shells=/run/current-system/sw/bin/nologin
    '';

  lightdmConf = writeText "lightdm.conf"
    ''
      [LightDM]
      ${optionalString cfg.greeter.enable ''
        greeter-user = ${config.users.users.lightdm.name}
        greeters-directory = ${cfg.greeter.package}
      ''}
      sessions-directory = ${dmcfg.sessionData.desktops}/share/xsessions:${dmcfg.sessionData.desktops}/share/wayland-sessions
      ${cfg.extraConfig}

      [Seat:*]
      xserver-command = ${xserverWrapper}
      session-wrapper = ${dmcfg.sessionData.wrapper}
      ${optionalString cfg.greeter.enable ''
        greeter-session = ${cfg.greeter.name}
      ''}
      ${optionalString dmcfg.autoLogin.enable ''
        autologin-user = ${dmcfg.autoLogin.user}
        autologin-user-timeout = ${toString cfg.autoLogin.timeout}
        autologin-session = ${sessionData.autologinSession}
      ''}
      ${optionalString (dmcfg.setupCommands != "") ''
        display-setup-script=${pkgs.writeScript "lightdm-display-setup" ''
          #!${pkgs.bash}/bin/bash
          ${dmcfg.setupCommands}
        ''}
      ''}
      ${cfg.extraSeatDefaults}
    '';

in
{
  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };

  # Note: the order in which lightdm greeter modules are imported
  # here determines the default: later modules (if enable) are
  # preferred.
  imports = [
    ./lightdm-greeters/gtk.nix
    ./lightdm-greeters/mini.nix
    ./lightdm-greeters/enso-os.nix
    ./lightdm-greeters/pantheon.nix
    ./lightdm-greeters/tiny.nix
    ./lightdm-greeters/slick.nix
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "lightdm" "autoLogin" "enable" ] [
      "services"
      "xserver"
      "displayManager"
      "autoLogin"
      "enable"
    ])
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "lightdm" "autoLogin" "user" ] [
     "services"
     "xserver"
     "displayManager"
     "autoLogin"
     "user"
    ])
  ];

  options = {

    services.xserver.displayManager.lightdm = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable lightdm as the display manager.
        '';
      };

      greeter =  {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            If set to false, run lightdm in greeterless mode. This only works if autologin
            is enabled and autoLogin.timeout is zero.
          '';
        };
        package = mkOption {
          type = types.package;
          description = lib.mdDoc ''
            The LightDM greeter to login via. The package should be a directory
            containing a .desktop file matching the name in the 'name' option.
          '';

        };
        name = mkOption {
          type = types.str;
          description = lib.mdDoc ''
            The name of a .desktop file in the directory specified
            in the 'package' option.
          '';
        };
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          user-authority-in-system-dir = true
        '';
        description = lib.mdDoc "Extra lines to append to LightDM section.";
      };

      background = mkOption {
        type = types.either types.path (types.strMatching "^#[0-9]\{6\}$");
        # Manual cannot depend on packages, we are actually setting the default in config below.
        defaultText = literalExpression "pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath";
        description = lib.mdDoc ''
          The background image or color to use.
        '';
      };

      extraSeatDefaults = mkOption {
        type = types.lines;
        default = "";
        example = ''
          greeter-show-manual-login=true
        '';
        description = lib.mdDoc "Extra lines to append to SeatDefaults section.";
      };

      # Configuration for automatic login specific to LightDM
      autoLogin.timeout = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Show the greeter for this many seconds before automatic login occurs.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = xcfg.enable;
        message = ''
          LightDM requires services.xserver.enable to be true
        '';
      }
      { assertion = dmcfg.autoLogin.enable -> sessionData.autologinSession != null;
        message = ''
          LightDM auto-login requires that services.xserver.displayManager.defaultSession is set.
        '';
      }
      { assertion = !cfg.greeter.enable -> (dmcfg.autoLogin.enable && cfg.autoLogin.timeout == 0);
        message = ''
          LightDM can only run without greeter if automatic login is enabled and the timeout for it
          is set to zero.
        '';
      }
    ];

    # Keep in sync with the defaultText value from the option definition.
    services.xserver.displayManager.lightdm.background = mkDefault pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath;

    # Set default session in session chooser to a specified values – basically ignore session history.
    # Auto-login is already covered by a config value.
    services.xserver.displayManager.job.preStart = optionalString (!dmcfg.autoLogin.enable && dmcfg.defaultSession != null) ''
      ${setSessionScript}/bin/set-session ${dmcfg.defaultSession}
    '';

    # setSessionScript needs session-files in XDG_DATA_DIRS
    services.xserver.displayManager.job.environment.XDG_DATA_DIRS = "${dmcfg.sessionData.desktops}/share/";

    # setSessionScript wants AccountsService
    systemd.services.display-manager.wants = [
      "accounts-daemon.service"
    ];

    # lightdm relaunches itself via just `lightdm`, so needs to be on the PATH
    services.xserver.displayManager.job.execCmd = ''
      export PATH=${lightdm}/sbin:$PATH
      exec ${lightdm}/sbin/lightdm
    '';

    # Replaces getty
    systemd.services.display-manager.conflicts = [
      "getty@tty7.service"
      # TODO: Add "plymouth-quit.service" so LightDM can control when plymouth
      # quits. Currently this breaks switching to configurations with plymouth.
     ];

    # Pull in dependencies of services we replace.
    systemd.services.display-manager.after = [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "getty@tty7.service"
      "user.slice"
    ];

    # user.slice needs to be present
    systemd.services.display-manager.requires = [
      "user.slice"
    ];

    # lightdm stops plymouth so when it fails make sure plymouth stops.
    systemd.services.display-manager.onFailure = [
      "plymouth-quit.service"
    ];

    systemd.services.display-manager.serviceConfig = {
      BusName = "org.freedesktop.DisplayManager";
      IgnoreSIGPIPE = "no";
      # This allows lightdm to pass the LUKS password through to PAM.
      # login keyring is unlocked automatic when autologin is used.
      KeyringMode = "shared";
      KillMode = "mixed";
      StandardError = "inherit";
    };

    environment.etc."lightdm/lightdm.conf".source = lightdmConf;
    environment.etc."lightdm/users.conf".source = usersConf;

    services.dbus.enable = true;
    services.dbus.packages = [ lightdm ];

    # lightdm uses the accounts daemon to remember language/window-manager per user
    services.accounts-daemon.enable = true;

    # Enable the accounts daemon to find lightdm's dbus interface
    environment.systemPackages = [ lightdm ];

    security.polkit.enable = true;

    security.pam.services.lightdm.text = ''
        auth      substack      login
        account   include       login
        password  substack      login
        session   include       login
    '';

    security.pam.services.lightdm-greeter.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = lightdm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = lightdm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = lightdm
        session  required       pam_env.so conffile=/etc/pam/environment readenv=0
        session  optional       ${config.systemd.package}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so
    '';

    security.pam.services.lightdm-autologin.text = ''
        auth      requisite     pam_nologin.so

        auth      required      pam_succeed_if.so uid >= 1000 quiet
        auth      required      pam_permit.so

        account   sufficient    pam_unix.so

        password  requisite     pam_unix.so nullok sha512

        session   optional      pam_keyinit.so revoke
        session   include       login
    '';

    users.users.lightdm = {
      home = "/var/lib/lightdm";
      group = "lightdm";
      uid = config.ids.uids.lightdm;
    };

    systemd.tmpfiles.rules = [
      "d /run/lightdm 0711 lightdm lightdm -"
      "d /var/cache/lightdm 0711 root lightdm -"
      "d /var/lib/lightdm 1770 lightdm lightdm -"
      "d /var/lib/lightdm-data 1775 lightdm lightdm -"
      "d /var/log/lightdm 0711 root lightdm -"
    ];

    users.groups.lightdm.gid = config.ids.gids.lightdm;
    services.xserver.tty     = null; # We might start multiple X servers so let the tty increment themselves..
    services.xserver.display = null; # We specify our own display (and logfile) in xserver-wrapper up there
  };
}
