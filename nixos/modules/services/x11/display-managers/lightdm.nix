{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  xEnv = config.systemd.services."display-manager".environment;
  cfg = dmcfg.lightdm;

  inherit (pkgs) stdenv lightdm writeScript writeText;

  # lightdm runs with clearenv(), but we need a few things in the enviornment for X to startup
  xserverWrapper = writeScript "xserver-wrapper"
    ''
      #! ${pkgs.bash}/bin/bash
      ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}

      display=$(echo "$@" | xargs -n 1 | grep -P ^:\\d\$ | head -n 1 | sed s/^://)
      if [ -z "$display" ]
      then additionalArgs=":0 -logfile /var/log/X.0.log"
      else additionalArgs="-logfile /var/log/X.$display.log"
      fi

      exec ${dmcfg.xserverBin} ${dmcfg.xserverArgs} $additionalArgs "$@"
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
      greeter-user = ${config.users.extraUsers.lightdm.name}
      greeters-directory = ${cfg.greeter.package}
      sessions-directory = ${dmcfg.session.desktops}

      [Seat:*]
      xserver-command = ${xserverWrapper}
      session-wrapper = ${dmcfg.session.script}
      greeter-session = ${cfg.greeter.name}
      ${cfg.extraSeatDefaults}
    '';
in
{
  # Note: the order in which lightdm greeter modules are imported
  # here determines the default: later modules (if enable) are
  # preferred.
  imports = [
    ./lightdm-greeters/gtk.nix
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

      background = mkOption {
        type = types.str;
        default = "${pkgs.nixos-artwork}/share/artwork/gnome/Gnome_Dark.png";
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

    };
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.slim.enable = false;

    services.xserver.displayManager.job = {
      logsXsession = true;

      # lightdm relaunches itself via just `lightdm`, so needs to be on the PATH
      execCmd = ''
        export PATH=${lightdm}/sbin:$PATH
        exec ${lightdm}/sbin/lightdm --log-dir=/var/log --run-dir=/run
      '';
    };

    environment.etc."lightdm/lightdm.conf".source = lightdmConf;
    environment.etc."lightdm/users.conf".source = usersConf;

    services.dbus.enable = true;
    services.dbus.packages = [ lightdm ];

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

    users.extraUsers.lightdm = {
      createHome = true;
      home = "/var/lib/lightdm-data";
      group = "lightdm";
      uid = config.ids.uids.lightdm;
    };

    users.extraGroups.lightdm.gid = config.ids.gids.lightdm;
    services.xserver.tty     = null; # We might start multiple X servers so let the tty increment themselves..
    services.xserver.display = null; # We specify our own display (and logfile) in xserver-wrapper up there
  };
}
