/*

NixOS support 2 fontconfig versions, "support" and "latest".

- "latest" refers to default fontconfig package (pkgs.fontconfig).
  configuration files are linked to /etc/fonts/VERSION/conf.d/
- "support" refers to supportPkg (pkgs."fontconfig_${supportVersion}").
  configuration files are linked to /etc/fonts/conf.d/

This module generates a package containing configuration files and link it in /etc/fonts.

Fontconfig reads files in folder name / file name order, so the number prepended to the configuration file name decide the order of parsing.
Low number means high priority.

*/

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
      fcPackage = if version == null
                  then "fontconfig"
                  else "fontconfig_${version}";
      makeCache = fontconfig: pkgs.makeFontsCache { inherit fontconfig; fontDirectories = config.fonts.fonts; };
      cache     = makeCache pkgs.${fcPackage};
      cache32   = makeCache pkgs.pkgsi686Linux.${fcPackage};
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

  # rendering settings configuration file
  # priority 10
  renderConf = pkgs.writeText "fc-10-nixos-rendering.conf" ''
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
        <edit mode="append" name="antialias">
          ${fcBool cfg.antialias}
        </edit>
        <edit mode="append" name="rgba">
          <const>${cfg.subpixel.rgba}</const>
        </edit>
        <edit mode="append" name="lcdfilter">
          <const>lcd${cfg.subpixel.lcdfilter}</const>
        </edit>
      </match>

      ${optionalString (cfg.dpi != 0) ''
      <match target="pattern">
        <edit name="dpi" mode="assign">
          <double>${toString cfg.dpi}</double>
        </edit>
      </match>
      ''}

    </fontconfig>
  '';

  # local configuration file
  localConf = pkgs.writeText "fc-local.conf" cfg.localConf;

  # default fonts configuration file
  # priority 52
  defaultFontsConf =
    let genDefault = fonts: name:
      optionalString (fonts != []) ''
        <alias binding="same">
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

      ${genDefault cfg.defaultFonts.emoji "emoji"}

    </fontconfig>
  '';

  # bitmap font options
  # priority 53
  rejectBitmaps = pkgs.writeText "fc-53-no-bitmaps.conf" ''
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

    <!-- Use embedded bitmaps in fonts like Calibri? -->
    <match target="font">
      <edit name="embeddedbitmap" mode="assign">
        ${fcBool cfg.useEmbeddedBitmaps}
      </edit>
    </match>

    </fontconfig>
  '';

  # reject Type 1 fonts
  # priority 53
  rejectType1 = pkgs.writeText "fc-53-nixos-reject-type1.conf" ''
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

  # fontconfig configuration package
  confPkg = pkgs.runCommand "fontconfig-conf" {
    preferLocalBuild = true;
  } ''
    support_folder=$out/etc/fonts/conf.d
    latest_folder=$out/etc/fonts/${latestVersion}/conf.d

    mkdir -p $support_folder
    mkdir -p $latest_folder

    # fonts.conf
    ln -s ${supportFontsConf} $support_folder/../fonts.conf
    ln -s ${latestPkg.out}/etc/fonts/fonts.conf \
          $latest_folder/../fonts.conf

    # fontconfig default config files
    ln -s ${supportPkg.out}/etc/fonts/conf.d/*.conf \
          $support_folder/
    ln -s ${latestPkg.out}/etc/fonts/conf.d/*.conf \
          $latest_folder/

    # update latest 51-local.conf path to look at the latest local.conf
    rm    $latest_folder/51-local.conf

    substitute ${latestPkg.out}/etc/fonts/conf.d/51-local.conf \
               $latest_folder/51-local.conf \
               --replace local.conf /etc/fonts/${latestVersion}/local.conf

    # 00-nixos-cache.conf
    ln -s ${cacheConfSupport} \
          $support_folder/00-nixos-cache.conf
    ln -s ${cacheConfLatest}  $latest_folder/00-nixos-cache.conf

    # 10-nixos-rendering.conf
    ln -s ${renderConf}       $support_folder/10-nixos-rendering.conf
    ln -s ${renderConf}       $latest_folder/10-nixos-rendering.conf

    # 50-user.conf
    ${optionalString (!cfg.includeUserConf) ''
    rm $support_folder/50-user.conf
    rm $latest_folder/50-user.conf
    ''}

    # local.conf (indirect priority 51)
    ${optionalString (cfg.localConf != "") ''
    ln -s ${localConf}        $support_folder/../local.conf
    ln -s ${localConf}        $latest_folder/../local.conf
    ''}

    # 52-nixos-default-fonts.conf
    ln -s ${defaultFontsConf} $support_folder/52-nixos-default-fonts.conf
    ln -s ${defaultFontsConf} $latest_folder/52-nixos-default-fonts.conf

    # 53-no-bitmaps.conf
    ln -s ${rejectBitmaps} $support_folder/53-no-bitmaps.conf
    ln -s ${rejectBitmaps} $latest_folder/53-no-bitmaps.conf

    ${optionalString (!cfg.allowType1) ''
    # 53-nixos-reject-type1.conf
    ln -s ${rejectType1} $support_folder/53-nixos-reject-type1.conf
    ln -s ${rejectType1} $latest_folder/53-nixos-reject-type1.conf
    ''}
  '';

  # Package with configuration files
  # this merge all the packages in the fonts.fontconfig.confPackages list
  fontconfigEtc = pkgs.buildEnv {
    name  = "fontconfig-etc";
    paths = cfg.confPackages;
    ignoreCollisions = true;
  };
in
{
  imports = [
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "allowBitmaps" ] [ "fonts" "fontconfig" "allowBitmaps" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "allowType1" ] [ "fonts" "fontconfig" "allowType1" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "useEmbeddedBitmaps" ] [ "fonts" "fontconfig" "useEmbeddedBitmaps" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "forceAutohint" ] [ "fonts" "fontconfig" "forceAutohint" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "renderMonoTTFAsBitmap" ] [ "fonts" "fontconfig" "renderMonoTTFAsBitmap" ])
    (mkRemovedOptionModule [ "fonts" "fontconfig" "hinting" "style" ] "")
    (mkRemovedOptionModule [ "fonts" "fontconfig" "forceAutohint" ] "")
    (mkRemovedOptionModule [ "fonts" "fontconfig" "renderMonoTTFAsBitmap" ] "")
  ];

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

        confPackages = mkOption {
          internal = true;
          type     = with types; listOf path;
          default  = [ ];
          description = ''
            Fontconfig configuration packages.
          '';
        };

        antialias = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Enable font antialiasing. At high resolution (> 200 DPI),
            antialiasing has no visible effect; users of such displays may want
            to disable this option.
          '';
        };

        dpi = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Force DPI setting. Setting to <literal>0</literal> disables DPI
            forcing; the DPI detected for the display will be used.
          '';
        };

        localConf = mkOption {
          type = types.lines;
          default = "";
          description = ''
            System-wide customization file contents, has higher priority than
            <literal>defaultFonts</literal> settings.
          '';
        };

        defaultFonts = {
          monospace = mkOption {
            type = types.listOf types.str;
            default = ["DejaVu Sans Mono"];
            description = ''
              System-wide default monospace font(s). Multiple fonts may be
              listed in case multiple languages must be supported.
            '';
          };

          sansSerif = mkOption {
            type = types.listOf types.str;
            default = ["DejaVu Sans"];
            description = ''
              System-wide default sans serif font(s). Multiple fonts may be
              listed in case multiple languages must be supported.
            '';
          };

          serif = mkOption {
            type = types.listOf types.str;
            default = ["DejaVu Serif"];
            description = ''
              System-wide default serif font(s). Multiple fonts may be listed
              in case multiple languages must be supported.
            '';
          };

          emoji = mkOption {
            type = types.listOf types.str;
            default = ["Noto Color Emoji"];
            description = ''
              System-wide default emoji font(s). Multiple fonts may be listed
              in case a font does not support all emoji.

              Note that fontconfig matches color emoji fonts preferentially,
              so if you want to use a black and white font while having
              a color font installed (eg. Noto Color Emoji installed alongside
              Noto Emoji), fontconfig will still choose the color font even
              when it is later in the list.
            '';
          };
        };

        hinting = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable font hinting. Hinting aligns glyphs to pixel boundaries to
              improve rendering sharpness at low resolution. At high resolution
              (> 200 dpi) hinting will do nothing (at best); users of such
              displays may want to disable this option.
            '';
          };

          autohint = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable the autohinter in place of the default interpreter.
              The results are usually lower quality than correctly-hinted
              fonts, but better than unhinted fonts.
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
            default = "rgb";
            type = types.enum ["rgb" "bgr" "vrgb" "vbgr" "none"];
            description = ''
              Subpixel order. The overwhelming majority of displays are
              <literal>rgb</literal> in their normal orientation. Select
              <literal>vrgb</literal> for mounting such a display 90 degrees
              clockwise from its normal orientation or <literal>vbgr</literal>
              for mounting 90 degrees counter-clockwise. Select
              <literal>bgr</literal> in the unlikely event of mounting 180
              degrees from the normal orientation. Reverse these directions in
              the improbable event that the display's native subpixel order is
              <literal>bgr</literal>.
            '';
          };

          lcdfilter = mkOption {
            default = "default";
            type = types.enum ["none" "default" "light" "legacy"];
            description = ''
              FreeType LCD filter. At high resolution (> 200 DPI), LCD filtering
              has no visible effect; users of such displays may want to select
              <literal>none</literal>.
            '';
          };

        };

        cache32Bit = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Generate system fonts cache for 32-bit applications.
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

      };

    };

  };
  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages    = [ pkgs.fontconfig ];
      environment.etc.fonts.source  = "${fontconfigEtc}/etc/fonts/";
    })
    (mkIf (cfg.enable && !cfg.penultimate.enable) {
      fonts.fontconfig.confPackages = [ confPkg ];
    })
  ];

}
