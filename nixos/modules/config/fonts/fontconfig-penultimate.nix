{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.fonts.fontconfig;

  fcBool = x: "<bool>" + (boolToString x) + "</bool>";

  # back-supported fontconfig version and package
  # version is used for font cache generation
  supportVersion = "210";
  supportPkg     = pkgs."fontconfig_${supportVersion}";

  # latest fontconfig version and package
  # version is used for configuration folder name, /etc/fonts/VERSION/
  # note: format differs from supportVersion and can not be used with makeCacheConf
  latestVersion  = pkgs.fontconfig.configVersion;
  latestPkg      = pkgs.fontconfig;

  # supported version fonts.conf
  supportFontsConf = pkgs.makeFontsConf { fontconfig = supportPkg; fontDirectories = config.fonts.fonts; };

  # configuration file to read fontconfig cache
  # version dependent
  # priority 0
  cacheConfSupport = makeCacheConf { version = supportVersion; };
  cacheConfLatest  = makeCacheConf {};

  # generate the font cache setting file for a fontconfig version
  # use latest when no version is passed
  makeCacheConf = { version ? null }:
    let
      fcPackage = if builtins.isNull version
                  then "fontconfig"
                  else "fontconfig_${version}";
      makeCache = fontconfig: pkgs.makeFontsCache { inherit fontconfig; fontDirectories = config.fonts.fonts; };
      cache     = makeCache pkgs."${fcPackage}";
      cache32   = makeCache pkgs.pkgsi686Linux."${fcPackage}";
    in
    pkgs.writeText "fc-00-nixos-cache.conf" ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>
        <!-- Font directories -->
        ${concatStringsSep "\n" (map (font: "<dir>${font}</dir>") config.fonts.fonts)}
        <!-- Pre-generated font caches -->
        <cachedir>${cache}</cachedir>
        ${optionalString (pkgs.stdenv.isx86_64 && cfg.cache32Bit) ''
          <cachedir>${cache32}</cachedir>
        ''}
      </fontconfig>
    '';

  # The configuration to be included in /etc/font/
  penultimateConf = pkgs.runCommand "font-penultimate-conf" {} ''
    support_folder=$out/etc/fonts/conf.d
    latest_folder=$out/etc/fonts/${latestVersion}/conf.d

    mkdir -p $support_folder
    mkdir -p $latest_folder

    ln -s ${supportFontsConf} $support_folder/../fonts.conf
    ln -s ${latestPkg.out}/etc/fonts/fonts.conf \
          $latest_folder/../fonts.conf

    # fontconfig-penultimate various configuration files
    ln -s ${pkgs.fontconfig-penultimate}/etc/fonts/conf.d/*.conf \
          $support_folder
    ln -s ${pkgs.fontconfig-penultimate}/etc/fonts/conf.d/*.conf \
          $latest_folder

    ln -s ${cacheConfSupport} $support_folder/00-nixos-cache.conf
    ln -s ${cacheConfLatest}  $latest_folder/00-nixos-cache.conf

    rm $support_folder/10-antialias.conf $latest_folder/10-antialias.conf
    ln -s ${antialiasConf} $support_folder/10-antialias.conf
    ln -s ${antialiasConf} $latest_folder/10-antialias.conf

    rm $support_folder/10-hinting.conf $latest_folder/10-hinting.conf
    ln -s ${hintingConf} $support_folder/10-hinting.conf
    ln -s ${hintingConf} $latest_folder/10-hinting.conf

    ${optionalString cfg.useEmbeddedBitmaps ''
    rm $support_folder/10-no-embedded-bitmaps.conf
    rm $latest_folder/10-no-embedded-bitmaps.conf
    ''}

    rm $support_folder/10-subpixel.conf $latest_folder/10-subpixel.conf
    ln -s ${subpixelConf} $support_folder/10-subpixel.conf
    ln -s ${subpixelConf} $latest_folder/10-subpixel.conf

    ${optionalString (cfg.dpi != 0) ''
    ln -s ${dpiConf} $support_folder/11-dpi.conf
    ln -s ${dpiConf} $latest_folder/11-dpi.conf
    ''}

    ${optionalString (!cfg.includeUserConf) ''
    rm $support_folder/50-user.conf
    rm $latest_folder/50-user.conf
    ''}

    # 51-local.conf
    rm $latest_folder/51-local.conf
    substitute \
      ${pkgs.fontconfig-penultimate}/etc/fonts/conf.d/51-local.conf \
      $latest_folder/51-local.conf \
      --replace local.conf /etc/fonts/${latestVersion}/local.conf

    ln -s ${defaultFontsConf} $support_folder/52-default-fonts.conf
    ln -s ${defaultFontsConf} $latest_folder/52-default-fonts.conf

    ${optionalString cfg.allowBitmaps ''
    rm $support_folder/53-no-bitmaps.conf
    rm $latest_folder/53-no-bitmaps.conf
    ''}

    ${optionalString (!cfg.allowType1) ''
    ln -s ${rejectType1} $support_folder/53-no-type1.conf
    ln -s ${rejectType1} $latest_folder/53-no-type1.conf
    ''}
  '';

  hintingConf = pkgs.writeText "fc-10-hinting.conf" ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>

      <!-- Default rendering settings -->
      <match target="pattern">
        <edit mode="append" name="hinting">
          ${fcBool cfg.hinting.enable}
        </edit>
        <edit mode="append" name="autohint">
          ${fcBool cfg.hinting.autohint}
        </edit>
        <edit mode="append" name="hintstyle">
          <const>hintslight</const>
        </edit>
      </match>

    </fontconfig>
  '';

  antialiasConf = pkgs.writeText "fc-10-antialias.conf" ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>

      <!-- Default rendering settings -->
      <match target="pattern">
        <edit mode="append" name="antialias">
          ${fcBool cfg.antialias}
        </edit>
      </match>

    </fontconfig>
  '';

  subpixelConf = pkgs.writeText "fc-10-subpixel.conf" ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>

      <!-- Default rendering settings -->
      <match target="pattern">
        <edit mode="append" name="rgba">
          <const>${cfg.subpixel.rgba}</const>
        </edit>
        <edit mode="append" name="lcdfilter">
          <const>lcd${cfg.subpixel.lcdfilter}</const>
        </edit>
      </match>

    </fontconfig>
  '';

  dpiConf = pkgs.writeText "fc-11-dpi.conf" ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>

      <match target="pattern">
        <edit name="dpi" mode="assign">
          <double>${toString cfg.dpi}</double>
        </edit>
      </match>

    </fontconfig>
  '';

  defaultFontsConf =
    let genDefault = fonts: name:
      optionalString (fonts != []) ''
        <alias>
          <family>${name}</family>
          <prefer>
          ${concatStringsSep ""
          (map (font: ''
            <family>${font}</family>
          '') fonts)}
          </prefer>
        </alias>
      '';
    in
    pkgs.writeText "fc-52-nixos-default-fonts.conf" ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>

      <!-- Default fonts -->
      ${genDefault cfg.defaultFonts.sansSerif "sans-serif"}

      ${genDefault cfg.defaultFonts.serif     "serif"}

      ${genDefault cfg.defaultFonts.monospace "monospace"}

    </fontconfig>
  '';

  rejectType1 = pkgs.writeText "fc-53-no-type1.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>

    <!-- Reject Type 1 fonts -->
    <selectfont>
      <rejectfont>
        <pattern>
          <patelt name="fontformat"><string>Type 1</string></patelt>
        </pattern>
      </rejectfont>
    </selectfont>

    </fontconfig>
  '';

in
{

  options = {

    fonts = {

      fontconfig = {

        penultimate = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable fontconfig-penultimate settings to supplement the
              NixOS defaults by providing per-font rendering defaults and
              metric aliases.
            '';
          };
        };

      };
    };

  };

  config = mkIf (config.fonts.fontconfig.enable && cfg.enable) {

    fonts.fontconfig.confPackages = [ penultimateConf ];

  };

}
