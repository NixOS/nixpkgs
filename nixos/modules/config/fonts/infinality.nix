{ config, pkgs, ... }:

with pkgs.lib;

let fontconfigBool = x: if x then "true" else "false";
    upstreamConf = "${pkgs.fontconfig}/etc/fonts/conf.d";
    infinalityPresets = rec {
      custom = {};

      default = {
        INFINALITY_FT_FILTER_PARAMS="11 22 38 22 11";
        INFINALITY_FT_GRAYSCALE_FILTER_STRENGTH="0";
        INFINALITY_FT_FRINGE_FILTER_STRENGTH="0";
        INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH="10";
        INFINALITY_FT_AUTOHINT_VERTICAL_STEM_DARKEN_STRENGTH="25";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="10";
        INFINALITY_FT_CHROMEOS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="25";
        INFINALITY_FT_STEM_FITTING_STRENGTH="25";
        INFINALITY_FT_GAMMA_CORRECTION="0 100";
        INFINALITY_FT_BRIGHTNESS="0";
        INFINALITY_FT_CONTRAST="0";
        INFINALITY_FT_USE_VARIOUS_TWEAKS="true";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="true";
        INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT="100";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="40";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="true";
        INFINALITY_FT_GLOBAL_EMBOLDEN_X_VALUE="0";
        INFINALITY_FT_GLOBAL_EMBOLDEN_Y_VALUE="0";
        INFINALITY_FT_BOLD_EMBOLDEN_X_VALUE="0";
        INFINALITY_FT_BOLD_EMBOLDEN_Y_VALUE="0";
      };

      osx = default // {
        INFINALITY_FT_FILTER_PARAMS="03 32 38 32 03";
        INFINALITY_FT_GRAYSCALE_FILTER_STRENGTH="25";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_GAMMA_CORRECTION="1000 80";
        INFINALITY_FT_BRIGHTNESS="10";
        INFINALITY_FT_CONTRAST="20";
        INFINALITY_FT_USE_VARIOUS_TWEAKS="false";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT="0";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="0";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
        INFINALITY_FT_GLOBAL_EMBOLDEN_Y_VALUE="8";
        INFINALITY_FT_BOLD_EMBOLDEN_X_VALUE="16";
      };

      ipad = default // {
        INFINALITY_FT_FILTER_PARAMS="00 00 100 00 00";
        INFINALITY_FT_GRAYSCALE_FILTER_STRENGTH="100";
        INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH="0";
        INFINALITY_FT_AUTOHINT_VERTICAL_STEM_DARKEN_STRENGTH="0";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_GAMMA_CORRECTION="1000 80";
        INFINALITY_FT_USE_VARIOUS_TWEAKS="false";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT="0";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="0";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
      };

      ubuntu = default // {
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_GAMMA_CORRECTION="1000 80";
        INFINALITY_FT_BRIGHTNESS="-10";
        INFINALITY_FT_CONTRAST="15";
        INFINALITY_FT_USE_VARIOUS_TWEAKS="false";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT="0";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="0";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
      };

      linux = default // {
        INFINALITY_FT_FILTER_PARAMS="06 25 44 25 06";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT="100";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
      };

      winxplight = default // {
        INFINALITY_FT_FILTER_PARAMS="06 25 44 25 06";
        INFINALITY_FT_FRINGE_FILTER_STRENGTH="100";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="65";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="15";
        INFINALITY_FT_STEM_FITTING_STRENGTH="15";
        INFINALITY_FT_GAMMA_CORRECTION="1000 120";
        INFINALITY_FT_BRIGHTNESS="20";
        INFINALITY_FT_CONTRAST="30";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="30";
      };

      win7light = default // {
        INFINALITY_FT_FILTER_PARAMS="20 25 38 25 05";
        INFINALITY_FT_FRINGE_FILTER_STRENGTH="100";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="100";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_GAMMA_CORRECTION="1000 160";
        INFINALITY_FT_CONTRAST="20";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="30";
      };

      winxp = default // {
        INFINALITY_FT_FILTER_PARAMS="06 25 44 25 06";
        INFINALITY_FT_FRINGE_FILTER_STRENGTH="100";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="65";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="15";
        INFINALITY_FT_STEM_FITTING_STRENGTH="15";
        INFINALITY_FT_GAMMA_CORRECTION="1000 120";
        INFINALITY_FT_BRIGHTNESS="10";
        INFINALITY_FT_CONTRAST="20";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="30";
      };

      win7 = default // {
        INFINALITY_FT_FILTER_PARAMS="20 25 42 25 06";
        INFINALITY_FT_FRINGE_FILTER_STRENGTH="100";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="65";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_GAMMA_CORRECTION="1000 120";
        INFINALITY_FT_BRIGHTNESS="10";
        INFINALITY_FT_CONTRAST="20";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="0";
      };

      vanilla = default // {
        INFINALITY_FT_FILTER_PARAMS="06 25 38 25 06";
        INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH="0";
        INFINALITY_FT_AUTOHINT_VERTICAL_STEM_DARKEN_STRENGTH="0";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_USE_VARIOUS_TWEAKS="false";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT="0";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="0";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
      };

      classic = default // {
        INFINALITY_FT_FILTER_PARAMS="06 25 38 25 06";
        INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH="0";
        INFINALITY_FT_AUTOHINT_VERTICAL_STEM_DARKEN_STRENGTH="0";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="0";
        INFINALITY_FT_STEM_FITTING_STRENGTH="0";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="0";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
      };

      nudge = default // {
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="30";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
      };

      push = default // {
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="75";
        INFINALITY_FT_STEM_FITTING_STRENGTH="50";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="30";
      };

      infinality = default // {
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="5";
      };

      shove = default // {
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="0";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="100";
        INFINALITY_FT_STEM_FITTING_STRENGTH="100";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="0";
      };

      sharpened = default // {
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="65";
      };

      disabled = default // {
        INFINALITY_FT_FILTER_PARAMS="";
        INFINALITY_FT_GRAYSCALE_FILTER_STRENGTH="";
        INFINALITY_FT_FRINGE_FILTER_STRENGTH="";
        INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH="";
        INFINALITY_FT_AUTOHINT_VERTICAL_STEM_DARKEN_STRENGTH="";
        INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH="";
        INFINALITY_FT_CHROMEOS_STYLE_SHARPENING_STRENGTH="";
        INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="";
        INFINALITY_FT_STEM_FITTING_STRENGTH="";
        INFINALITY_FT_GAMMA_CORRECTION="0 100";
        INFINALITY_FT_BRIGHTNESS="0";
        INFINALITY_FT_CONTRAST="0";
        INFINALITY_FT_USE_VARIOUS_TWEAKS="false";
        INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="false";
        INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT="";
        INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE="";
        INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS="false";
        INFINALITY_FT_GLOBAL_EMBOLDEN_X_VALUE="0";
        INFINALITY_FT_GLOBAL_EMBOLDEN_Y_VALUE="0";
        INFINALITY_FT_BOLD_EMBOLDEN_X_VALUE="0";
        INFINALITY_FT_BOLD_EMBOLDEN_Y_VALUE="0";
      };
    };
in
{

  options = {

    fonts = {

      infinality = {
        allowType1 = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow Type-1 fonts. Disabled by default because they render poorly.
          '';
        };

        bitmapMonospace = mkOption {
          type = types.bool;
          default = false;
          description = ''Render bitmaps for some monospace TrueType fonts?'';
        };

        dpi = mkOption {
          type = types.string;
          default = "96";
          description = ''Set your display resolution here.'';
        };

        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Enable Infinality font rendering. Infinality is a set of patches
            for FreeType which implement subpixel rendering. This option
            enables the Fontconfig settings recommended for Infinality.
          '';
        };

        forceAutohint = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Forcibly enable the auto-hinter everywhere. Useful for debugging
            and for free software purists.
          '';
        };

        preferOutline = mkOption {
          type = types.bool;
          default = true;
          description = ''Substitute TrueType fonts in place of bitmaps?'';
        };

        qtSubpixel = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable subpixel positioning in Qt. Some Infinality options may lead
            to incorrect subpixel positioning, but it should be safe to enable
            this option if fitting is disabled.
          '';
        };

        style = mkOption {
          type = types.string;
          default = "infinality";
          description = ''
            Select from Infinality Fontconfig presets. Must be one of
            <literal>infinality</literal>,
            <literal>linux</literal>,
            <literal>osx</literal>,
            <literal>osx2</literal>,
            <literal>win7</literal>,
            <literal>win98</literal>, or
            <literal>winxp</literal>.
          '';
        };

        freetypeStyle = mkOption {
          type = types.string;
          default = "default";
          description = ''
            Select from Infinality FreeType presets. Must be one of
            <literal>default</literal>,
            <literal>osx</literal>,
            <literal>ipad</literal>,
            <literal>ubuntu</literal>,
            <literal>linux</literal>,
            <literal>winxplight</literal>,
            <literal>win7light</literal>,
            <literal>winxp</literal>,
            <literal>win7</literal>,
            <literal>vanilla</literal>,
            <literal>classic</literal>,
            <literal>nudge</literal>,
            <literal>push</literal>,
            <literal>shove</literal>,
            <literal>sharpened</literal>,
            <literal>infinality</literal>,
            <literal>custom</literal>, or
            <literal>disabled</literal>.
            <literal>custom</literal> does not set any environment variables;
            you must set them yourself to activate Infinality.
          '';
        };

        substitutions = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Enable Infinality's style-specific substitutions. Corrective
            substitutions will still be done if this is disabled.
          '';
        };
      };
    };

  };


  config =
    let fontconfig = config.fonts.fontconfig;
        infinality = config.fonts.infinality;
    in mkIf config.fonts.enableFontConfig {

      environment.etc."fonts/conf.d/52-infinality.conf" = {
        text =
          ''
            <?xml version='1.0'?>
            <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
            <fontconfig>

              ${optionalString (!infinality.allowType1)
                ''
                  <selectfont>
                    <rejectfont>
                      <pattern>
                        <patelt name="fontformat" >
                          <string>Type 1</string>
                        </patelt>
                      </pattern>
                    </rejectfont>
                  </selectfont>
                ''
              }

              <match target="pattern" >
                <edit name="prefer_outline" mode="assign">
                  <bool>${fontconfigBool infinality.preferOutline}</bool>
                </edit>
              </match>

              <match target="pattern" >
                <edit name="do_substitutions" mode="assign">
                  <bool>${fontconfigBool infinality.substitutions}</bool>
                </edit>
              </match>

              <match target="pattern" >
                <edit name="bitmap_monospace" mode="assign">
                  <bool>${fontconfigBool infinality.bitmapMonospace}</bool>
                </edit>
              </match>

              <match target="font">
                <edit name="force_autohint" mode="assign">
                  <bool>${fontconfigBool infinality.forceAutohint}</bool>
                </edit>
              </match>

              <match target="pattern">
                <edit name="dpi" mode="assign">
                  <double>${infinality.dpi}</double>
                </edit>
              </match>

              <match target="pattern" >
                <edit name="qt_use_subpixel_positioning" mode="assign">
                  <bool>${fontconfigBool infinality.qtSubpixel}</bool>
                </edit>
              </match>

              <include>${pkgs.fontconfig}/etc/fonts/infinality/styles.conf.avail/${infinality.style}</include>

            </fontconfig>
          '';
        enable = infinality.enable;
      };

      environment.variables =
        if infinality.enable
          then getAttr infinality.freetypeStyle infinalityPresets
          else infinalityPresets.disabled;

    };

}
