{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) stdenv;
  
  kernelPackages = config.boot.kernelPackages;
  splashutils = kernelPackages.splashutils;
  requiredTTYs = config.requiredTTYs;
  
  backgrounds =
    let
    
      specificThemes = config.services.ttyBackgrounds.specificThemes;
        
      overridenTTYs = map (x: x.tty) specificThemes;

      # Use the default theme for all the mingetty ttys and for the
      # syslog tty, except those for which a specific theme is
      # specified.
      defaultTTYs =
        filter (x: !(elem x overridenTTYs)) requiredTTYs;

    in      
      (map (tty: { inherit tty; }) defaultTTYs) ++ specificThemes;

  themesUnpacked = stdenv.mkDerivation {
    name = "splash-themes";
    builder = ./tty-backgrounds-combine.sh;
    default = unpackTheme config.services.ttyBackgrounds.defaultTheme;
    # !!! Should use XML here.
    ttys = map (x: x.tty) backgrounds;
    themes = map (x: if x ? theme then unpackTheme x.theme else "default") backgrounds;
  };

  unpackTheme = theme: import ../../lib/unpack-theme.nix {
    inherit stdenv theme;
  };

in

{

  ###### interface
  
  options = {
  
    services.ttyBackgrounds = {

      enable = mkOption {
        default = true;
        description = ''
          Whether to enable graphical backgrounds for the virtual consoles.
        '';
      };

      defaultTheme = mkOption {
        default = pkgs.fetchurl {
          #url = http://www.bootsplash.de/files/themes/Theme-BabyTux.tar.bz2;
          url = mirror://gentoo/distfiles/Theme-BabyTux.tar.bz2;
          md5 = "a6d89d1c1cff3b6a08e2f526f2eab4e0";
        };
        description = ''
          The default theme for the virtual consoles.  Themes can be found
          at <link xlink:href='http://www.bootsplash.de/' />.
        '';
      };

      specificThemes = mkOption {
        default = [ ];
        description = ''
          This option overrides the theme for specific virtual consoles.
        '';
      };
      
    };
    
  };


  ###### implementation

  config = mkIf config.services.ttyBackgrounds.enable {

    assertions = singleton
      { assertion = kernelPackages.splashutils != null;
        message = "kernelPackages.splashutils may not be false";
      };

    services.ttyBackgrounds.specificThemes = singleton
      { tty = config.services.syslogd.tty;
        theme = pkgs.themes "theme-gnu";
      };

    environment.etc = singleton
      { source = themesUnpacked;
        target = "splash";
      };

    jobs.ttyBackgrounds =
      { name = "tty-backgrounds";

        startOn = "started udev";

        preStart =
          ''
            # Critical: tell the kernel where to find splash_helper.  It calls
            # this program every time we switch between consoles.
            helperProcFile=${splashutils.helperProcFile}
            if test -e /proc/sys/fbcondecor; then helperProcFile=/proc/sys/fbcondecor; fi
            echo ${splashutils}/${splashutils.helperName} > $helperProcFile

            # For each console...
            for tty in ${toString (map (x: x.tty) backgrounds)}; do
                # Make sure that the console exists.
                echo -n "" > /dev/$tty

                # Set the theme as determined by tty-backgrounds-combine.sh
                # above.  Note that splashutils needs a TTY number
                # instead of a device name, hence the ''${tty:3}.
                theme=$(readlink ${themesUnpacked}/$tty)
                prevTheme=$(${splashutils}/${splashutils.controlName} --tty ''${tty:3} -c getcfg |
                    sed 's/theme: *\(.*\)/\1/;t;d' || true)
                if [ "$theme" != "$prevTheme" ]; then
                    ${splashutils}/${splashutils.controlName} --tty ''${tty:3} -c setcfg -t $theme || true
                fi
                ${splashutils}/${splashutils.controlName} --tty ''${tty:3} -c setpic -t $theme || true
                ${splashutils}/${splashutils.controlName} --tty ''${tty:3} -c on || true
            done
          '';

        postStop =
          ''
            # Disable the theme on each console.
            for tty in ${toString (map (x: x.tty) backgrounds)}; do
                ${splashutils}/${splashutils.controlName} --tty ''${tty:3} -c off || true
            done
          '';
      };
    
  };
  
}
