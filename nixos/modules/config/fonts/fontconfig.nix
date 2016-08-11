/*

NixOS support 2 fontconfig versions, "support" and "latest".

- "latest" refers to default fontconfig package (pkgs.fontconfig).
  configuration files are linked to /etc/fonts/VERSION/conf.d/
- "support" refers to supportPkg (pkgs."fontconfig_${supportVersion}").
  configuration files are linked to /etc/fonts/conf.d/

This module generates a package containing configuration files and link it in /etc/fonts.

Fontconfig reads files in folder name / file name order, so the number prepended to the configuration file name decide the order of parsing.
Low number means high priority.

Default fonts should have a high priority (low number) to be at the head of the preferred fonts list, fontconfig advise the 30~40 range.

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

      </fontconfig>
    '';

    # prefered default fonts configuration file
    # priority 30
    genericAliasConf = 
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
      pkgs.writeText "fc-30-nixos-generic-alias.conf" ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>

        <!-- Default fonts -->
        ${genDefault cfg.defaultFonts.sansSerif "sans-serif"}

        ${genDefault cfg.defaultFonts.serif     "serif"}

        ${genDefault cfg.defaultFonts.monospace "monospace"}

      </fontconfig>
    '';

    # user settings configuration file
    # priority 99
    userConf = pkgs.writeText "fc-99-user.conf" ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <include ignore_missing="yes" prefix="xdg">fontconfig/conf.d</include>
        <include ignore_missing="yes" prefix="xdg">fontconfig/fonts.conf</include>
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

      # 00-nixos-cache.conf
      ln -s ${cacheConfSupport} \
            $support_folder/conf.d/00-nixos-cache.conf
      ln -s ${cacheConfLatest}  $latest_folder/conf.d/00-nixos-cache.conf

      # 10-nixos-rendering.conf
      ln -s ${renderConf}       $support_folder/conf.d/10-nixos-rendering.conf
      ln -s ${renderConf}       $latest_folder/conf.d/10-nixos-rendering.conf

      # 30-nixos-generic-alias.conf
      ln -s ${genericAliasConf} $support_folder/conf.d/30-nixos-generic-alias.conf
      ln -s ${genericAliasConf} $latest_folder/conf.d/30-nixos-generic-alias.conf

      # 99-user.conf
      ${optionalString cfg.includeUserConf ''
      ln -s ${userConf}         $support_folder/conf.d/99-user.conf
      ln -s ${userConf}         $latest_folder/conf.d/99-user.conf
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
            default = "rgb";
            type = types.enum ["rgb" "bgr" "vrgb" "vbgr" "none"];
            description = ''
              Subpixel order, one of <literal>none</literal>,
              <literal>rgb</literal>, <literal>bgr</literal>,
              <literal>vrgb</literal>, or <literal>vbgr</literal>.
            '';
          };

          lcdfilter = mkOption {
            default = "default";
            type = types.enum ["none" "default" "light" "legacy"];
            description = ''
              FreeType LCD filter, one of <literal>none</literal>,
              <literal>default</literal>, <literal>light</literal>, or
              <literal>legacy</literal>.
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

      };

    };

  };
  config = mkIf cfg.enable {
    fonts.fontconfig.confPackages = [ confPkg ];

    environment.systemPackages    = [ pkgs.fontconfig ];
    environment.etc.fonts.source  = "${fontconfigEtc}/etc/fonts/";
  };

}
