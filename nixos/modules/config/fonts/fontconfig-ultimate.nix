{ config, pkgs, lib, ... }:

with lib;

let fcBool = x: if x then "<bool>true</bool>" else "<bool>false</bool>";

    cfg = config.fonts.fontconfig.ultimate;

    latestVersion  = pkgs.fontconfig.configVersion;

    # fontconfig ultimate main configuration file
    # priority 52
    fontconfigUltimateConf = pkgs.writeText "fc-52-fontconfig-ultimate.conf" ''
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

    # The configuration to be included in /etc/font/
    confPkg = pkgs.runCommand "font-ultimate-conf" {} ''
      support_folder=$out/etc/fonts/conf.d
      latest_folder=$out/etc/fonts/${latestVersion}/conf.d

      mkdir -p $support_folder
      mkdir -p $latest_folder

      # 52-fontconfig-ultimate.conf
      ln -s ${fontconfigUltimateConf} \
            $support_folder/52-fontconfig-ultimate.conf
      ln -s ${fontconfigUltimateConf} \
            $latest_folder/52-fontconfig-ultimate.conf

      # fontconfig ultimate substitutions
      ${optionalString (cfg.substitutions != "none") ''
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/presets/${cfg.substitutions}/*.conf \
            $support_folder
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/presets/${cfg.substitutions}/*.conf \
            $latest_folder
      ''}

      # fontconfig ultimate various configuration files
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/conf.d/*.conf \
            $support_folder
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/conf.d/*.conf \
            $latest_folder
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

  config = mkIf (config.fonts.fontconfig.enable && cfg.enable) {

    fonts.fontconfig.confPackages = [ confPkg ];
    environment.variables."INFINALITY_FT" = cfg.preset;

  };

}
