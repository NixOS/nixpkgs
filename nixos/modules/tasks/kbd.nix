{ config, lib, pkgs, ... }:

with lib;

let

  makeColor = n: value: "COLOR_${toString n}=${value}";
  makeColorCS =
    let positions = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ];
    in n: value: "\\033]P${elemAt positions (n - 1)}${value}";
  colors = concatImapStringsSep "\n" makeColor config.i18n.consoleColors;

  isUnicode = hasSuffix "UTF-8" (toUpper config.i18n.defaultLocale);

  optimizedKeymap = pkgs.runCommand "keymap" {
    nativeBuildInputs = [ pkgs.kbd ];
    LOADKEYS_KEYMAP_PATH = "${kbdEnv}/share/keymaps/**";
  } ''
    loadkeys -b ${optionalString isUnicode "-u"} "${config.i18n.consoleKeyMap}" > $out
  '';

  # Sadly, systemd-vconsole-setup doesn't support binary keymaps.
  vconsoleConf = pkgs.writeText "vconsole.conf" ''
    KEYMAP=${config.i18n.consoleKeyMap}
    FONT=${config.i18n.consoleFont}
    ${colors}
  '';

  kbdEnv = pkgs.buildEnv {
    name = "kbd-env";
    paths = [ pkgs.kbd ] ++ config.i18n.consolePackages;
    pathsToLink = [ "/share/consolefonts" "/share/consoletrans" "/share/keymaps" "/share/unimaps" ];
  };

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

    boot.earlyVconsoleSetup = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable setting font as early as possible (in initrd).
      '';
    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf (!setVconsole || (setVconsole && config.boot.earlyVconsoleSetup)) {
      systemd.services."systemd-vconsole-setup".enable = false;
    })

    (mkIf setVconsole (mkMerge [
      { environment.systemPackages = [ pkgs.kbd ];

        # Let systemd-vconsole-setup.service do the work of setting up the
        # virtual consoles.
        environment.etc."vconsole.conf".source = vconsoleConf;
        # Provide kbd with additional packages.
        environment.etc."kbd".source = "${kbdEnv}/share";

        boot.initrd.preLVMCommands = mkBefore ''
          kbd_mode ${if isUnicode then "-u" else "-a"} -C /dev/console
          printf "\033%%${if isUnicode then "G" else "@"}" >> /dev/console
          loadkmap < ${optimizedKeymap}

          ${optionalString config.boot.earlyVconsoleSetup ''
            setfont -C /dev/console $extraUtils/share/consolefonts/font.psf
          ''}

          ${concatImapStringsSep "\n" (n: color: ''
            printf "${makeColorCS n color}" >> /dev/console
          '') config.i18n.consoleColors}
        '';
      }

      (mkIf (!config.boot.earlyVconsoleSetup) {
        # This is identical to the systemd-vconsole-setup.service unit
        # shipped with systemd, except that it uses /dev/tty1 instead of
        # /dev/tty0 to prevent putting the X server in non-raw mode, and
        # it has a restart trigger.
        systemd.services."systemd-vconsole-setup" =
          { wantedBy = [ "sysinit.target" ];
            before = [ "display-manager.service" ];
            after = [ "systemd-udev-settle.service" ];
            restartTriggers = [ vconsoleConf kbdEnv ];
          };
      })

      (mkIf config.boot.earlyVconsoleSetup {
        boot.initrd.extraUtilsCommands = ''
          mkdir -p $out/share/consolefonts
          ${if substring 0 1 config.i18n.consoleFont == "/" then ''
            font="${config.i18n.consoleFont}"
          '' else ''
            font="$(echo ${kbdEnv}/share/consolefonts/${config.i18n.consoleFont}.*)"
          ''}
          if [[ $font == *.gz ]]; then
            gzip -cd $font > $out/share/consolefonts/font.psf
          else
            cp -L $font $out/share/consolefonts/font.psf
          fi
        '';
      })
    ]))
  ];

}
