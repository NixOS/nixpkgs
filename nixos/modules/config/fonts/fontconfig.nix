{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    fonts = {

      enableFontConfig = mkOption { # !!! should be enableFontconfig
        type = types.bool;
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

    # Fontconfig 2.10 backward compatibility

    # Bring in the default (upstream) fontconfig configuration, only for fontconfig 2.10
    environment.etc."fonts/fonts.conf".source =
      pkgs.makeFontsConf { fontconfig = pkgs.fontconfig_210; fontDirectories = config.fonts.fonts; };

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

    # Versioned fontconfig > 2.10. Only specify font directories.

    environment.etc."fonts/${pkgs.fontconfig.configVersion}/conf.d/00-nixos.conf".text =
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

          <!-- Font directories -->
          ${concatStringsSep "\n" (map (font: "<dir>${font}</dir>") config.fonts.fonts)}

        </fontconfig>
      '';

    environment.systemPackages = [ pkgs.fontconfig ];

  };

}
