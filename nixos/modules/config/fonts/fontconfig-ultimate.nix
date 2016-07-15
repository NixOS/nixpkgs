{ config, pkgs, lib, ... }:

with lib;

let fcBool = x: if x then "<bool>true</bool>" else "<bool>false</bool>";
    cfg = config.fonts.fontconfig.ultimate;
    fontconfigUltimateConf = pkgs.writeText "ultimate-conf" ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>

        ${optionalString (!cfg.allowBitmaps) ''
        <!-- Reject bitmap fonts -->
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="scalable"><bool>false</bool></patelt>
            </pattern>
          </rejectfont>
        </selectfont>
        ''}

        ${optionalString cfg.allowType1 ''
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
            ${fcBool cfg.useEmbeddedBitmaps}
          </edit>
        </match>

        <!-- Force autohint always -->
        <match target="font">
          <edit name="force_autohint" mode="assign">
            ${fcBool cfg.forceAutohint}
          </edit>
        </match>

        <!-- Render some monospace TTF fonts as bitmaps -->
        <match target="pattern">
          <edit name="bitmap_monospace" mode="assign">
            ${fcBool cfg.renderMonoTTFAsBitmap}
          </edit>
        </match>

      </fontconfig>
    '';
    confPkg = 
      let version = pkgs.fontconfig.configVersion;
      in pkgs.runCommand "font-ultimate-conf" {} ''
      mkdir -p $out/etc/fonts/{,${version}/}conf.d/

      cp ${fontconfigUltimateConf} \
        $out/etc/fonts/conf.d/52-fontconfig-ultimate.conf

      cp ${fontconfigUltimateConf} \
        $out/etc/fonts/${version}/conf.d/52-fontconfig-ultimate.conf

      ${optionalString (cfg.substitutions != "none") ''
      cp ${pkgs.fontconfig-ultimate.confd}/etc/fonts/presets/${cfg.substitutions}/*.conf \
        $out/etc/fonts/conf.d/
      cp ${pkgs.fontconfig-ultimate.confd}/etc/fonts/presets/${cfg.substitutions}/*.conf \
        $out/etc/fonts/${version}/conf.d/
      ''}

      ln -s ${pkgs.fontconfig-ultimate.confd}/etc/fonts/conf.d/*.conf \
        $out/etc/fonts/conf.d/

      ln -s ${pkgs.fontconfig-ultimate.confd}/etc/fonts/conf.d/*.conf \
        $out/etc/fonts/${version}/conf.d/
    '';

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
            type = types.str // {
              check = flip elem ["none" "free" "combi" "ms"];
            };
            default = "free";
            description = ''
              Font substitutions to replace common Type 1 fonts with nicer
              TrueType fonts. <literal>free</literal> uses free fonts,
              <literal>ms</literal> uses Microsoft fonts,
              <literal>combi</literal> uses a combination, and
              <literal>none</literal> disables the substitutions.
            '';
          };

          rendering = mkOption {
            type = types.attrs;
            default = pkgs.fontconfig-ultimate.rendering.ultimate;
            description = ''
              FreeType rendering settings presets. The default is
              <literal>pkgs.fontconfig-ultimate.rendering.ultimate</literal>.
              The other available styles are:
              <literal>ultimate-lighter</literal>,
              <literal>ultimate-darker</literal>,
              <literal>ultimate-lightest</literal>,
              <literal>ultimate-darkest</literal>,
              <literal>default</literal> (the original Infinality default),
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
              <literal>infinality</literal>. Any of the presets may be
              customized by editing the attributes. To disable, set this option
              to the empty attribute set <literal>{}</literal>.
            '';
          };
        };
      };
    };

  };


  config = mkIf (config.fonts.fontconfig.enable && cfg.enable) {

      fonts.fontconfig.confPkgs = [ confPkg ];
      
      environment.variables = cfg.rendering;

    };

}
