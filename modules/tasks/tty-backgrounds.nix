{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      ttyBackgrounds = {

        enable = mkOption {
          default = true;
          description = "
            Whether to enable graphical backgrounds for the virtual consoles.
          ";
        };

        defaultTheme = mkOption {
          default = pkgs.fetchurl {
            #url = http://www.bootsplash.de/files/themes/Theme-BabyTux.tar.bz2;
            url = mirror://gentoo/distfiles/Theme-BabyTux.tar.bz2;
            md5 = "a6d89d1c1cff3b6a08e2f526f2eab4e0";
          };
          description = "
            The default theme for the virtual consoles.  Themes can be found
            at <link xlink:href='http://www.bootsplash.de/' />.
          ";
        };

        defaultSpecificThemes = mkOption {
          default = [
            /*
            { tty = 6;
              theme = pkgs.fetchurl { # Yeah!
                url = mirror://gentoo/distfiles/Theme-Pativo.tar.bz2;
                md5 = "9e13beaaadf88d43a5293e7ab757d569";
              };
            }
            */
            { tty = 10;
              theme = pkgs.themes "theme-gnu";
            }
          ];
          description = "
            This option sets specific themes for virtual consoles.  If you
            just want to set themes for additional consoles, use
            <option>services.ttyBackgrounds.specificThemes</option>.
          ";
        };

        specificThemes = mkOption {
          default = [
          ];
          description = "
            This option allows you to set specific themes for virtual
            consoles.
          ";
        };
      };
    };
  };
in

###### implementation

let
  inherit (pkgs) stdenv;
  kernelPackages = config.boot.kernelPackages;
  splashutils = kernelPackages.splashutils;
  requiredTTYs = config.requiredTTYs;
  backgrounds =
  
    let
    
      specificThemes =
        config.services.ttyBackgrounds.defaultSpecificThemes
        ++ config.services.ttyBackgrounds.specificThemes;
        
      overridenTTYs = map (x: x.tty) specificThemes;

      # Use the default theme for all the mingetty ttys and for the
      # syslog tty, except those for which a specific theme is
      # specified.
      defaultTTYs =
        pkgs.lib.filter (x: !(pkgs.lib.elem x overridenTTYs)) requiredTTYs;

    in      
      (map (ttyNumber: {
        tty = ttyNumber;
        theme = config.services.ttyBackgrounds.defaultTheme;
      }) defaultTTYs)
      ++ specificThemes;


  themesUnpacked = stdenv.mkDerivation {
    name = "splash-themes";
    builder = ./tty-backgrounds-combine.sh;
    # !!! Should use XML here.
    ttys = map (x: x.tty) backgrounds;
    themes = map (x: if x ? theme then (unpackTheme x.theme) else "default") backgrounds;
  };

  unpackTheme = theme: import ../../lib/unpack-theme.nix {
      inherit stdenv theme;
    };



in

mkIf (config.services.ttyBackgrounds.enable) {

  assertions = [ { assertion = kernelPackages.splashutils != null; message = "kernelPackages.splashutils may not be false"; } ];

  require = [
    options
  ];


  environment = {
    etc = [
      { source = themesUnpacked;
        target = "splash";
      }
    ];
  };


  services = {
    extraJobs = [ rec {
      name = "tty-backgrounds";

      job = ''
        start on udev

        start script

            # Critical: tell the kernel where to find splash_helper.  It calls
            # this program every time we switch between consoles.
            helperProcFile=${splashutils.helperProcFile}
            if test -e /proc/sys/fbcondecor; then helperProcFile=/proc/sys/fbcondecor; fi
            echo ${splashutils}/${splashutils.helperName} > $helperProcFile

            # For each console...
            for tty in ${toString (map (x: x.tty) backgrounds)}; do
                # Make sure that the console exists.
                echo -n "" > /dev/tty$tty 

                # Set the theme as determined by tty-backgrounds-combine.sh
                # above.
                theme=$(readlink ${themesUnpacked}/$tty)
                ${splashutils}/${splashutils.controlName} --tty $tty -c setcfg -t $theme || true
                ${splashutils}/${splashutils.controlName} --tty $tty -c setpic -t $theme || true
                ${splashutils}/${splashutils.controlName} --tty $tty -c on || true
            done

        end script

        respawn sleep 10000 # !!! Hack

        stop script
            # Disable the theme on each console.
            for tty in ${toString (map (x: x.tty) backgrounds)}; do
                ${splashutils}/${splashutils.controlName} --tty $tty -c off || true
            done
        end script
      '';
    }];
  };
}
