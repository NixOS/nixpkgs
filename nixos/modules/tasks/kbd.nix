{ config, lib, pkgs, ... }:

with lib;

let

  makeColor = n: value: "COLOR_${toString n}=${value}";
  colors = concatImapStringsSep "\n" makeColor config.i18n.consoleColors;

  vconsoleConf = pkgs.writeText "vconsole.conf" ''
    KEYMAP=${config.i18n.consoleKeyMap}
    FONT=${config.i18n.consoleFont}
    ${colors}
  '';

  setVconsole = !config.boot.isContainer;
in

{
  ###### interface

  options = {

    # most options are defined in i18n.nix

    # FIXME: still needed?
    boot.extraTTYs = mkOption {
      default = [];
      type = types.listOf types.str;
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

  };


  ###### implementation

  config = mkMerge [
    (mkIf (!setVconsole) {
      systemd.services."systemd-vconsole-setup".enable = false;
    })

    (mkIf setVconsole {
      environment.systemPackages = [ pkgs.kbd ];

      # Let systemd-vconsole-setup.service do the work of setting up the
      # virtual consoles.  FIXME: trigger a restart of
      # systemd-vconsole-setup.service if /etc/vconsole.conf changes.
      environment.etc = [ {
        target = "vconsole.conf";
        source = vconsoleConf;
      } ];

      # This is identical to the systemd-vconsole-setup.service unit
      # shipped with systemd, except that it uses /dev/tty1 instead of
      # /dev/tty0 to prevent putting the X server in non-raw mode, and
      # it has a restart trigger.
      systemd.services."systemd-vconsole-setup" =
        { wantedBy = [ "multi-user.target" ];
          before = [ "display-manager.service" ];
          after = [ "systemd-udev-settle.service" ];
          restartTriggers = [ vconsoleConf ];
        };
    })
  ];

}
