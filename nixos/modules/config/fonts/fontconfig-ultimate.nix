{ config, pkgs, lib, ... }:

with lib;

let fcBool = x: if x then "<bool>true</bool>" else "<bool>false</bool>";
in
{

  options = {

    fonts = {

      fontconfig = {

        ultimate = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable fontconfig-ultimate settings (formerly known as
              Infinality). Besides the customizable settings in this NixOS
              module, fontconfig-ultimate also provides many font-specific
              rendering tweaks.
            '';
          };

          allowBitmaps = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Allow bitmap fonts. Set to <literal>false</literal> to ban all
              bitmap fonts.
            '';
          };

          allowType1 = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Allow Type-1 fonts. Default is <literal>false</literal> because of
              poor rendering.
            '';
          };

          useEmbeddedBitmaps = mkOption {
            type = types.bool;
            default = false;
            description = ''Use embedded bitmaps in fonts like Calibri.'';
          };

          forceAutohint = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Force use of the TrueType Autohinter. Useful for debugging or
              free-software purists.
            '';
          };

          renderMonoTTFAsBitmap = mkOption {
            type = types.bool;
            default = false;
            description = ''Render some monospace TTF fonts as bitmaps.'';
          };

          substitutions = mkOption {
            type = types.nullOr (types.enum ["free" "combi" "ms"]);
            default = "free";
            description = ''
              Font substitutions to replace common Type 1 fonts with nicer
              TrueType fonts. <literal>free</literal> uses free fonts,
              <literal>ms</literal> uses Microsoft fonts,
              <literal>combi</literal> uses a combination, and
              <literal>none</literal> disables the substitutions.
            '';
          };

          preset = mkOption {
            type = types.enum ["ultimate1" "ultimate2" "ultimate3" "ultimate4" "ultimate5" "osx" "windowsxp"];
            default = "ultimate3";
            description = ''
              FreeType rendering settings preset. Any of the presets may be
              customized by setting environment variables.
            '';
          };
        };
      };
    };

  };


  config =
    let ultimate = config.fonts.fontconfig.ultimate;
        fontconfigUltimateConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>

            ${optionalString (!ultimate.allowBitmaps) ''
            <!-- Reject bitmap fonts -->
            <selectfont>
              <rejectfont>
                <pattern>
                  <patelt name="scalable"><bool>false</bool></patelt>
                </pattern>
              </rejectfont>
            </selectfont>
            ''}

            ${optionalString ultimate.allowType1 ''
            <!-- Reject Type 1 fonts -->
            <selectfont>
              <rejectfont>
                <pattern>
                  <patelt name="fontformat">
                    <string>Type 1</string>
                  </patelt>
                </pattern>
              </rejectfont>
            </selectfont>
            ''}

            <!-- Use embedded bitmaps in fonts like Calibri? -->
            <match target="font">
              <edit name="embeddedbitmap" mode="assign">
                ${fcBool ultimate.useEmbeddedBitmaps}
              </edit>
            </match>

            <!-- Force autohint always -->
            <match target="font">
              <edit name="force_autohint" mode="assign">
                ${fcBool ultimate.forceAutohint}
              </edit>
            </match>

            <!-- Render some monospace TTF fonts as bitmaps -->
            <match target="pattern">
              <edit name="bitmap_monospace" mode="assign">
                ${fcBool ultimate.renderMonoTTFAsBitmap}
              </edit>
            </match>

            ${optionalString (ultimate.substitutions != null) ''
            <!-- Type 1 font substitutions -->
            <include ignore_missing="yes">${pkgs.fontconfig-ultimate}/etc/fonts/presets/${ultimate.substitutions}</include>
            ''}

            <include ignore_missing="yes">${pkgs.fontconfig-ultimate}/etc/fonts/conf.d</include>

          </fontconfig>
        '';
    in mkIf (config.fonts.fontconfig.enable && ultimate.enable) {

      environment.etc."fonts/conf.d/52-fontconfig-ultimate.conf" = {
        text = fontconfigUltimateConf;
      };

      environment.etc."fonts/${pkgs.fontconfig.configVersion}/conf.d/52-fontconfig-ultimate.conf" = {
        text = fontconfigUltimateConf;
      };

      environment.variables."INFINALITY_FT" = ultimate.preset;

    };

}
