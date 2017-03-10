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

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.fonts.fontconfig;

    fcBool = x: "<bool>" + (if x then "true" else "false") + "</bool>";

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

    # rendering settings configuration file
    # priority 10
    renderConf = pkgs.writeText "fc-10-nixos-rendering.conf" ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>

        <!-- Default rendering settings -->
        <match target="font">
          <edit mode="assign" name="hinting">
            ${fcBool cfg.hinting.enable}
          </edit>
          <edit mode="assign" name="autohint">
            ${fcBool cfg.hinting.autohint}
          </edit>
          <edit mode="assign" name="hintstyle">
            <const>hint${cfg.hinting.style}</const>
          </edit>
          <edit mode="assign" name="antialias">
            ${fcBool cfg.antialias}
          </edit>
          <edit mode="assign" name="rgba">
            <const>${cfg.subpixel.rgba}</const>
          </edit>
          <edit mode="assign" name="lcdfilter">
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

        <!-- Force autohint always -->
        <match target="font">
          <edit name="force_autohint" mode="assign">
            ${fcBool cfg.forceAutohint}
          </edit>
        </match>

      </fontconfig>
    '';

    # local configuration file
    # priority 51
    localConf = pkgs.writeText "fc-local.conf" cfg.localConf;

    # default fonts configuration file
    # priority 52
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

    # bitmap font options
    # priority 53
    rejectBitmaps = pkgs.writeText "fc-53-nixos-bitmaps.conf" ''
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

      <!-- Render some monospace TTF fonts as bitmaps -->
      <match target="pattern">
        <edit name="bitmap_monospace" mode="assign">
          ${fcBool cfg.renderMonoTTFAsBitmap}
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
    confPkg = pkgs.runCommand "fontconfig-conf" {} ''
      support_folder=$out/etc/fonts
      latest_folder=$out/etc/fonts/${latestVersion}

      mkdir -p $support_folder/conf.d
      mkdir -p $latest_folder/conf.d

      # fonts.conf
      ln -s ${supportFontsConf} $support_folder/fonts.conf
      ln -s ${latestPkg.out}/etc/fonts/fonts.conf \
            $latest_folder/fonts.conf

      # fontconfig default config files
      ln -s ${supportPkg.out}/etc/fonts/conf.d/*.conf \
            $support_folder/conf.d/
      ln -s ${latestPkg.out}/etc/fonts/conf.d/*.conf \
            $latest_folder/conf.d/

      # update latest 51-local.conf path to look at the latest local.conf
      rm    $latest_folder/conf.d/51-local.conf

      substitute ${latestPkg.out}/etc/fonts/conf.d/51-local.conf \
                 $latest_folder/conf.d/51-local.conf \
                 --replace local.conf /etc/fonts/${latestVersion}/local.conf

      # 00-nixos-cache.conf
      ln -s ${cacheConfSupport} \
            $support_folder/conf.d/00-nixos-cache.conf
      ln -s ${cacheConfLatest}  $latest_folder/conf.d/00-nixos-cache.conf

      # 10-nixos-rendering.conf
      ln -s ${renderConf}       $support_folder/conf.d/10-nixos-rendering.conf
      ln -s ${renderConf}       $latest_folder/conf.d/10-nixos-rendering.conf

      # 50-user.conf
      ${optionalString (! cfg.includeUserConf) ''
      rm    $support_folder/conf.d/50-user.conf
      rm    $latest_folder/conf.d/50-user.conf
      ''}

      # local.conf (indirect priority 51)
      ${optionalString (cfg.localConf != "") ''
      ln -s ${localConf}        $support_folder/local.conf
      ln -s ${localConf}        $latest_folder/local.conf
      ''}

      # 52-nixos-default-fonts.conf
      ln -s ${defaultFontsConf} $support_folder/conf.d/52-nixos-default-fonts.conf
      ln -s ${defaultFontsConf} $latest_folder/conf.d/52-nixos-default-fonts.conf

      # 53-nixos-bitmaps.conf
      ln -s ${rejectBitmaps} $support_folder/conf.d/53-nixos-bitmaps.conf
      ln -s ${rejectBitmaps} $latest_folder/conf.d/53-nixos-bitmaps.conf

      ${optionalString (! cfg.allowType1) ''
      # 53-nixos-reject-type1.conf
      ln -s ${rejectType1} $support_folder/conf.d/53-nixos-reject-type1.conf
      ln -s ${rejectType1} $latest_folder/conf.d/53-nixos-reject-type1.conf
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
            type = types.enum ["none" "slight" "medium" "full"];
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
            default = "rgb";
            type = types.enum ["rgb" "bgr" "vrgb" "vbgr" "none"];
            description = ''
              Subpixel order.
            '';
          };

          lcdfilter = mkOption {
            default = "default";
            type = types.enum ["none" "default" "light" "legacy"];
            description = ''
              FreeType LCD filter.
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

      };

    };

  };
  config = mkIf cfg.enable {
    fonts.fontconfig.confPackages = [ confPkg ];

    environment.systemPackages    = [ pkgs.fontconfig ];
    environment.etc.fonts.source  = "${fontconfigEtc}/etc/fonts/";
  };

}
