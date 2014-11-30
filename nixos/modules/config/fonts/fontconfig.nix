{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    fonts = {

      fontconfig = {
        enable = mkOption {
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

        antialias = mkOption {
          type = types.bool;
          default = true;
          description = "Enable font antialiasing.";
        };

        dpi = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Force DPI setting. Setting to <literal>0</literal> disables DPI
            forcing; the DPI detected for the display will be used.
          '';
        };

        defaultFonts = {
          monospace = mkOption {
            type = types.str;
            default = "DejaVu Sans Mono";
            description = ''
              System-wide default monospace font. The default is not set if the
              option is set to <literal>""</literal>.
            '';
          };

          sansSerif = mkOption {
            type = types.str;
            default = "DejaVu Sans";
            description = ''
              System-wide default sans serif font. The default is not set if the
              option is set to <literal>""</literal>.
            '';
          };

          serif = mkOption {
            type = types.str;
            default = "DejaVu Serif";
            description = ''
              System-wide default serif font. The default is not set if the
              option is set to <literal>""</literal>.
            '';
          };
        };

        hinting = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Enable TrueType hinting.";
          };

          autohint = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable the autohinter, which provides hinting for otherwise
              un-hinted fonts. The results are usually lower quality than
              correctly-hinted fonts.
            '';
          };

          style = mkOption {
            type = types.str // {
              check = flip elem ["none" "slight" "medium" "full"];
            };
            default = "full";
            description = ''
              TrueType hinting style, one of <literal>none</literal>,
              <literal>slight</literal>, <literal>medium</literal>, or
              <literal>full</literal>.
            '';
          };
        };

        includeUserConf = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Include the user configuration from
            <filename>~/.config/fontconfig/fonts.conf</filename> or
            <filename>~/.config/fontconfig/conf.d</filename>.
          '';
        };

        subpixel = {

          rgba = mkOption {
            type = types.string // {
              check = flip elem ["rgb" "bgr" "vrgb" "vbgr" "none"];
            };
            default = "rgb";
            description = ''
              Subpixel order, one of <literal>none</literal>,
              <literal>rgb</literal>, <literal>bgr</literal>,
              <literal>vrgb</literal>, or <literal>vbgr</literal>.
            '';
          };

          lcdfilter = mkOption {
            type = types.str // {
              check = flip elem ["none" "default" "light" "legacy"];
            };
            default = "default";
            description = ''
              FreeType LCD filter, one of <literal>none</literal>,
              <literal>default</literal>, <literal>light</literal>, or
              <literal>legacy</literal>.
            '';
          };

        };

      };

    };

  };

  config =
    let fontconfig = config.fonts.fontconfig;
        fcBool = x: "<bool>" + (if x then "true" else "false") + "</bool>";
    in mkIf fontconfig.enable {

      # Fontconfig 2.10 backward compatibility

      # Bring in the default (upstream) fontconfig configuration, only for fontconfig 2.10
      environment.etc."fonts/fonts.conf".source =
        pkgs.makeFontsConf { fontconfig = pkgs.fontconfig_210; fontDirectories = config.fonts.fonts; };

      environment.etc."fonts/conf.d/98-nixos.conf".text =
        ''
          <?xml version='1.0'?>
          <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
          <fontconfig>

            <!-- Default rendering settings -->
            <match target="font">
              <edit mode="assign" name="hinting">
                ${fcBool fontconfig.hinting.enable}
              </edit>
              <edit mode="assign" name="autohint">
                ${fcBool fontconfig.hinting.autohint}
              </edit>
              <edit mode="assign" name="hintstyle">
                <const>hint${fontconfig.hinting.style}</const>
              </edit>
              <edit mode="assign" name="antialias">
                ${fcBool fontconfig.antialias}
              </edit>
              <edit mode="assign" name="rgba">
                <const>${fontconfig.subpixel.rgba}</const>
              </edit>
              <edit mode="assign" name="lcdfilter">
                <const>lcd${fontconfig.subpixel.lcdfilter}</const>
              </edit>
            </match>

            <!-- Default fonts -->
            ${optionalString (fontconfig.defaultFonts.sansSerif != "") ''
            <alias>
              <family>sans-serif</family>
              <prefer>
                <family>${fontconfig.defaultFonts.sansSerif}</family>
              </prefer>
            </alias>
            ''}
            ${optionalString (fontconfig.defaultFonts.serif != "") ''
            <alias>
              <family>serif</family>
              <prefer>
                <family>${fontconfig.defaultFonts.serif}</family>
              </prefer>
            </alias>
            ''}
            ${optionalString (fontconfig.defaultFonts.monospace != "") ''
            <alias>
              <family>monospace</family>
              <prefer>
                <family>${fontconfig.defaultFonts.monospace}</family>
              </prefer>
            </alias>
            ''}

            ${optionalString (fontconfig.dpi != 0) ''
            <match target="pattern">
              <edit name="dpi" mode="assign">
                <double>${fontconfig.dpi}</double>
              </edit>
            </match>
            ''}

          </fontconfig>
        '';

      # Versioned fontconfig > 2.10. Take shared fonts.conf from fontconfig.
      # Otherwise specify only font directories.
      environment.etc."fonts/${pkgs.fontconfig.configVersion}/fonts.conf".source =
        "${pkgs.fontconfig}/etc/fonts/fonts.conf";

      environment.etc."fonts/${pkgs.fontconfig.configVersion}/conf.d/00-nixos.conf".text =
        ''
          <?xml version='1.0'?>
          <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
          <fontconfig>
            <!-- Font directories -->
            ${concatStringsSep "\n" (map (font: "<dir>${font}</dir>") config.fonts.fonts)}
          </fontconfig>
        '';

      environment.etc."fonts/${pkgs.fontconfig.configVersion}/conf.d/98-nixos.conf".text =
        ''
          <?xml version='1.0'?>
          <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
          <fontconfig>

            <!-- Default rendering settings -->
            <match target="font">
              <edit mode="assign" name="hinting">
                ${fcBool fontconfig.hinting.enable}
              </edit>
              <edit mode="assign" name="autohint">
                ${fcBool fontconfig.hinting.autohint}
              </edit>
              <edit mode="assign" name="hintstyle">
                <const>hint${fontconfig.hinting.style}</const>
              </edit>
              <edit mode="assign" name="antialias">
                ${fcBool fontconfig.antialias}
              </edit>
              <edit mode="assign" name="rgba">
                <const>${fontconfig.subpixel.rgba}</const>
              </edit>
              <edit mode="assign" name="lcdfilter">
                <const>lcd${fontconfig.subpixel.lcdfilter}</const>
              </edit>
            </match>

            <!-- Default fonts -->
            <alias>
              <family>sans-serif</family>
              <prefer>
                <family>${fontconfig.defaultFonts.sansSerif}</family>
              </prefer>
            </alias>
            <alias>
              <family>serif</family>
              <prefer>
                <family>${fontconfig.defaultFonts.serif}</family>
              </prefer>
            </alias>
            <alias>
              <family>monospace</family>
              <prefer>
                <family>${fontconfig.defaultFonts.monospace}</family>
              </prefer>
            </alias>

            ${optionalString (fontconfig.dpi != 0) ''
            <match target="pattern">
              <edit name="dpi" mode="assign">
                <double>${fontconfig.dpi}</double>
              </edit>
            </match>
            ''}

          </fontconfig>
        '';

      environment.etc."fonts/${pkgs.fontconfig.configVersion}/conf.d/99-user.conf" = {
        enable = fontconfig.includeUserConf;
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <include ignore_missing="yes" prefix="xdg">fontconfig/conf.d</include>
            <include ignore_missing="yes" prefix="xdg">fontconfig/fonts.conf</include>
          </fontconfig>
        '';
      };

      environment.systemPackages = [ pkgs.fontconfig ];

    };

}
