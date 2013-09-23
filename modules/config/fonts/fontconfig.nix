{ config, pkgs, ... }:

with pkgs.lib;

{

  options = {

    fonts = {

      enableFontConfig = mkOption { # !!! should be enableFontconfig
        default = true;
        description = ''
          If enabled, a Fontconfig configuration file will be built
          pointing to a set of default fonts.  If you don't care about
          running X11 applications or any other program that uses
          Fontconfig, you can turn this option off and prevent a
          dependency on all those fonts.
        '';
      };

    };

  };


  config = mkIf config.fonts.enableFontConfig {

    # Bring in the default (upstream) fontconfig configuration.
    environment.etc."fonts/fonts.conf".source =
      pkgs.makeFontsConf { fontDirectories = config.fonts.fonts; };

    environment.etc."fonts/conf.d/00-nixos.conf".text =
      ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>

          <!-- Set the default hinting style to "slight". -->
          <match target="font">
            <edit mode="assign" name="hintstyle">
              <const>hintslight</const>
            </edit>
          </match>

        </fontconfig>
      '';

    # FIXME: This variable is no longer needed, but we'll keep it
    # around for a while for applications linked against old
    # fontconfig builds.
    environment.variables.FONTCONFIG_FILE = "/etc/fonts/fonts.conf";

    environment.systemPackages = [ pkgs.fontconfig ];

  };

}
