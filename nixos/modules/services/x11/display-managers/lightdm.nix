{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  xEnv = config.systemd.services."display-manager".environment;
  cfg = dmcfg.lightdm;

  dmDefault = xcfg.desktopManager.default;
  wmDefault = xcfg.windowManager.default;
  hasDefaultUserSession = dmDefault != "none" || wmDefault != "none";

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
      sessions-directory = ${dmcfg.session.desktops}/share/xsessions
      ${cfg.extraConfig}

      [Seat:*]
      xserver-command = ${xserverWrapper}
      session-wrapper = ${dmcfg.session.wrapper}
      ${optionalString cfg.greeter.enable ''
        greeter-session = ${cfg.greeter.name}
      ''}
      ${optionalString cfg.autoLogin.enable ''
        autologin-user = ${cfg.autoLogin.user}
        autologin-user-timeout = ${toString cfg.autoLogin.timeout}
        autologin-session = ${defaultSessionName}
      ''}
      ${optionalString hasDefaultUserSession ''
        user-session=${defaultSessionName}
      ''}
      ${optionalString (dmcfg.setupCommands != "") ''
        display-setup-script=${pkgs.writeScript "lightdm-display-setup" ''
          #!${pkgs.bash}/bin/bash
          ${dmcfg.setupCommands}
        ''}
      ''}
      ${cfg.extraSeatDefaults}
    '';

  defaultSessionName = dmDefault + optionalString (wmDefault != "none") ("+" + wmDefault);
in
{
  # Note: the order in which lightdm greeter modules are imported
  # here determines the default: later modules (if enable) are
  # preferred.
  imports = [
    ./lightdm-greeters/gtk.nix
    ./lightdm-greeters/mini.nix
    ./lightdm-greeters/enso-os.nix
  ];

  options = {

    services.xserver.displayManager.lightdm = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable lightdm as the display manager.
        '';
      };

      greeter =  {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            If set to false, run lightdm in greeterless mode. This only works if autologin
            is enabled and autoLogin.timeout is zero.
          '';
        };
        package = mkOption {
          type = types.package;
          description = ''
            The LightDM greeter to login via. The package should be a directory
            containing a .desktop file matching the name in the 'name' option.
          '';

        };
        name = mkOption {
          type = types.string;
          description = ''
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
        description = "Extra lines to append to LightDM section.";
      };

      background = mkOption {
        type = types.str;
        default = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom}/share/artwork/gnome/nix-wallpaper-simple-dark-gray_bottom.png";
        description = ''
          The background image or color to use.
        '';
      };

      extraSeatDefaults = mkOption {
        type = types.lines;
        default = "";
        example = ''
          greeter-show-manual-login=true
        '';
        description = "Extra lines to append to SeatDefaults section.";
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
                Automatically log in as the specified <option>autoLogin.user</option>.
              '';
            };

            user = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                User to be used for the automatic login.
              '';
            };

            timeout = mkOption {
              type = types.int;
              default = 0;
              description = ''
                Show the greeter for this many seconds before automatic login occurs.
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
          LightDM auto-login requires services.xserver.displayManager.lightdm.autoLogin.user to be set
        '';
      }
      { assertion = cfg.autoLogin.enable -> dmDefault != "none" || wmDefault != "none";
        message = ''
          LightDM auto-login requires that services.xserver.desktopManager.default and
          services.xserver.windowManager.default are set to valid values. The current
          default session: ${defaultSessionName} is not valid.
        '';
      }
      { assertion = !cfg.greeter.enable -> (cfg.autoLogin.enable && cfg.autoLogin.timeout == 0);
        message = ''
          LightDM can only run without greeter if automatic login is enabled and the timeout for it
          is set to zero.
        '';
      }
    ];

    # lightdm relaunches itself via just `lightdm`, so needs to be on the PATH
    services.xserver.displayManager.job.execCmd = ''
      export PATH=${lightdm}/sbin:$PATH
      exec ${lightdm}/sbin/lightdm
    '';

    environment.etc."lightdm/lightdm.conf".source = lightdmConf;
    environment.etc."lightdm/users.conf".source = usersConf;

    services.dbus.enable = true;
    services.dbus.packages = [ lightdm ];

    # lightdm uses the accounts daemon to remember language/window-manager per user
    services.accounts-daemon.enable = true;

    # Enable the accounts daemon to find lightdm's dbus interface
    environment.systemPackages = [ lightdm ];

    security.pam.services.lightdm = {
      allowNullPassword = true;
      startSession = true;
    };
    security.pam.services.lightdm-greeter = {
      allowNullPassword = true;
      startSession = true;
      text = ''
        auth     required pam_env.so envfile=${config.system.build.pamEnvironment}
        auth     required pam_permit.so

        account  required pam_permit.so

        password required pam_deny.so

        session  required pam_env.so envfile=${config.system.build.pamEnvironment}
        session  required pam_unix.so
        session  optional ${pkgs.systemd}/lib/security/pam_systemd.so
      '';
    };
    security.pam.services.lightdm-autologin.text = ''
        auth     requisite pam_nologin.so
        auth     required  pam_succeed_if.so uid >= 1000 quiet
        auth     required  pam_permit.so

        account  include   lightdm

        password include   lightdm

        session  include   lightdm
    '';

    users.users.lightdm = {
      home = "/var/lib/lightdm";
      group = "lightdm";
      uid = config.ids.uids.lightdm;
    };

    systemd.tmpfiles.rules = [
      "d /run/lightdm 0711 lightdm lightdm 0"
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
