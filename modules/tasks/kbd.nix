{ config, pkgs, ... }:

with pkgs.lib;

let

  # think about where to put this chunk of code!
  # required by other pieces as well
  requiredTTYs = config.services.mingetty.ttys
    ++ config.boot.extraTTYs
    ++ [ config.services.syslogd.tty ];
  ttys = map (dev: "/dev/${dev}") requiredTTYs;
  defaultLocale = config.i18n.defaultLocale;
  consoleFont = config.i18n.consoleFont;
  consoleKeyMap = config.i18n.consoleKeyMap;

in

{
  ###### interface

  options = {

    # most options are defined in i18n.nix

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

    environment.systemPackages = [pkgs.kbd];
  
    jobs.kbd =
      { description = "Keyboard / console initialisation";

        startOn = "started udev";

        task = true;

        script = ''
          export LANG=${defaultLocale}
          export LOCALE_ARCHIVE=/var/run/current-system/sw/lib/locale/locale-archive
          export PATH=${pkgs.gzip}/bin:$PATH # Needed by setfont

          set +e # continue in case of errors


          # Enable or disable UTF-8 mode.  This is based on
          # unicode_{start,stop}.
          echo 'Enabling or disabling Unicode mode...'

          charMap=$(${pkgs.glibc}/bin/locale charmap)

          if test "$charMap" = UTF-8; then

            for tty in ${toString ttys}; do

              # Tell the console output driver that the bytes arriving are
              # UTF-8 encoded multibyte sequences. 
              echo -n -e '\033%G' > $tty

            done

            # Set the keyboard driver in UTF-8 mode.
            ${pkgs.kbd}/bin/kbd_mode -u

          else

            for tty in ${toString ttys}; do

              # Tell the console output driver that the bytes arriving are
              # UTF-8 encoded multibyte sequences. 
              echo -n -e '\033%@' > $tty

            done

            # Set the keyboard driver in ASCII (or any 8-bit character
            # set) mode.
            ${pkgs.kbd}/bin/kbd_mode -a

          fi


          # Set the console font.
          for tty in ${toString ttys}; do
            ${pkgs.kbd}/bin/setfont -C $tty ${consoleFont}
          done


          # Set the keymap.
          ${pkgs.kbd}/bin/loadkeys '${consoleKeyMap}'
        '';
      };

  };

}
