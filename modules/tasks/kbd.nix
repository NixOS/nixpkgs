{ config, pkgs, ... }:

with pkgs.lib;

let

  # think about where to put this chunk of code!
  # required by other pieces as well
  requiredTTYs = config.services.mingetty.ttys
    ++ config.boot.extraTTYs
    ++ [ config.services.syslogd.tty ];
  ttys = map (dev: "/dev/${dev}") requiredTTYs;
  consoleFont = config.i18n.consoleFont;
  consoleKeyMap = config.i18n.consoleKeyMap;

  vconsoleConf = pkgs.writeText "vconsole.conf"
    ''
      KEYMAP=${consoleKeyMap}
      FONT=${consoleFont}
    '';

in

{
  ###### interface

  options = {

    # most options are defined in i18n.nix

    # FIXME: still needed?
    boot.extraTTYs = mkOption {
      default = [];
      example = ["tty8" "tty9"];
      description = ''
        Tty (virtual console) devices, in addition to the consoles on
        which mingetty and syslogd run, that must be initialised.
        Only useful if you have some program that you want to run on
        some fixed console.  For example, the NixOS installation CD
        opens the manual in a web browser on console 7, so it sets
        <option>boot.extraTTYs</option> to <literal>["tty7"]</literal>.
      '';
    };

    # dummy option so that requiredTTYs can be passed
    requiredTTYs = mkOption {
      default = [];
      description = "
        FIXME: find another place for this option.
        FIXME: find a good description.
      ";
    };

  };


  ###### implementation

  config = {

    inherit requiredTTYs; # pass it to ./modules/tasks/tty-backgrounds.nix

    environment.systemPackages = [ pkgs.kbd ];

    # Let systemd-vconsole-setup.service do the work of setting up the
    # virtual consoles.  FIXME: trigger a restart of
    # systemd-vconsole-setup.service if /etc/vconsole.conf changes.
    environment.etc = singleton
      { target = "vconsole.conf";
        source = vconsoleConf;
      };

    # This is identical to the systemd-vconsole-setup.service unit
    # shipped with systemd, except that it uses /dev/tty1 instead of
    # /dev/tty0 to prevent putting the X server in non-raw mode, and
    # it has a restart trigger.
    systemd.services."systemd-vconsole-setup" =
      { description = "Setup Virtual Console";
        before = [ "sysinit.target" "shutdown.target" ];
        unitConfig =
          { DefaultDependencies = "no";
            Conflicts = "shutdown.target";
            ConditionPathExists = "/dev/tty1";
          };
        serviceConfig =
          { Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${config.system.build.systemd}/lib/systemd/systemd-vconsole-setup /dev/tty1";
          };
        restartTriggers = [ vconsoleConf ];
      };

  };

}
