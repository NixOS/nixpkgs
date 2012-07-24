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
        source = pkgs.writeText "vconsole.conf"
          ''
            KEYMAP=${consoleKeyMap}
            FONT=${consoleFont}
          '';
      };

  };

}
