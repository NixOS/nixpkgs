{ config, lib, pkgs, ... }:

with lib;

let cfg = config.fonts.fontconfig;
    fcBool = x: "<bool>" + (if x then "true" else "false") + "</bool>";
    renderConf = pkgs.writeText "render-conf" ''
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
      pkgs.writeText "generic-alias-conf" ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>

        <!-- Default fonts -->
        ${genDefault cfg.defaultFonts.sansSerif "sans-serif"}

        ${genDefault cfg.defaultFonts.serif     "serif"}

        ${genDefault cfg.defaultFonts.monospace "monospace"}

      </fontconfig>
    '';
    cacheConf = let
      cache = fontconfig: pkgs.makeFontsCache { inherit fontconfig; fontDirectories = config.fonts.fonts; };
    in
    pkgs.writeText "cache-conf" ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>
        <!-- Font directories -->
        ${concatStringsSep "\n" (map (font: "<dir>${font}</dir>") config.fonts.fonts)}
        <!-- Pre-generated font caches -->
        <cachedir>${cache pkgs.fontconfig}</cachedir>
        ${optionalString (pkgs.stdenv.isx86_64 && cfg.cache32Bit) ''
          <cachedir>${cache pkgs.pkgsi686Linux.fontconfig}</cachedir>
        ''}
      </fontconfig>
    '';
    userConf = pkgs.writeText "user-conf" ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <include ignore_missing="yes" prefix="xdg">fontconfig/conf.d</include>
        <include ignore_missing="yes" prefix="xdg">fontconfig/fonts.conf</include>
      </fontconfig>
    '';
    fontsConf = pkgs.makeFontsConf { fontconfig = pkgs.fontconfig_210; fontDirectories = config.fonts.fonts; };
    confPkg = 
      let version = pkgs.fontconfig.configVersion;
      in pkgs.runCommand "fontconfig-conf" {} ''
      mkdir -p $out/etc/fonts/{,${version}/}conf.d

      ln -s ${fontsConf}        $out/etc/fonts/fonts.conf

      ln -s ${pkgs.fontconfig.out}/etc/fonts/fonts.conf $out/etc/fonts/${version}/fonts.conf
      ln -s ${pkgs.fontconfig.out}/etc/fonts/conf.d/*   $out/etc/fonts/${version}/conf.d/

      ln -s ${renderConf}       $out/etc/fonts/conf.d/10-nixos-rendering.conf
      ln -s ${genericAliasConf} $out/etc/fonts/conf.d/60-nixos-generic-alias.conf

      ln -s ${cacheConf}        $out/etc/fonts/${version}/conf.d/00-nixos.conf

      ln -s ${renderConf}       $out/etc/fonts/${version}/conf.d/10-nixos-rendering.conf
      ln -s ${genericAliasConf} $out/etc/fonts/${version}/conf.d/30-nixos-generic-alias.conf

      ${optionalString cfg.includeUserConf
      "ln -s ${userConf}        $out/etc/fonts/${version}/conf.d/99-user.conf"}
      
    '';
in
{

  options = {

    fonts = {

      fontconfig = {
        enable = mkOption {
          type = types.bool;
          default = config.services.xserver.enable;
          description = ''
            If enabled, a Fontconfig configuration file will be built
            pointing to a set of default fonts.  If you don't care about
            running X11 applications or any other program that uses
            Fontconfig, you can turn this option off and prevent a
            dependency on all those fonts.
          '';
        };

        confPkgs = mkOption {
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
    fonts.fontconfig.confPkgs = [ confPkg ];

    environment.etc.fonts.source = 
      let fontConf = pkgs.symlinkJoin {
            name  = "fontconfig-etc";
            paths = cfg.confPkgs;
          };
      in "${fontConf}/etc/fonts/";

    environment.systemPackages = [ pkgs.fontconfig ];
  };

}
