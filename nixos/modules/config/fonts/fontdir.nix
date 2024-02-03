{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.fonts.fontDir;

  x11Fonts = pkgs.runCommand "X11-fonts" { preferLocalBuild = true; } ''
    mkdir -p "$out/share/X11/fonts"
    font_regexp='.*\.\(ttf\|ttc\|otb\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
    find ${toString config.fonts.packages} -regex "$font_regexp" \
      -exec ln -sf -t "$out/share/X11/fonts" '{}' \;
    cd "$out/share/X11/fonts"
    ${optionalString cfg.decompressFonts ''
      ${pkgs.gzip}/bin/gunzip -f *.gz
    ''}
    ${pkgs.xorg.mkfontscale}/bin/mkfontscale
    ${pkgs.xorg.mkfontdir}/bin/mkfontdir
    cat $(find ${pkgs.xorg.fontalias}/ -name fonts.alias) >fonts.alias
  '';

in

{

  options = {
    fonts.fontDir = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to create a directory with links to all fonts in
          {file}`/run/current-system/sw/share/X11/fonts`.
        '';
      };

      decompressFonts = mkOption {
        type = types.bool;
        default = config.programs.xwayland.enable;
        defaultText = literalExpression "config.programs.xwayland.enable";
        description = lib.mdDoc ''
          Whether to decompress fonts in
          {file}`/run/current-system/sw/share/X11/fonts`.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ x11Fonts ];
    environment.pathsToLink = [ "/share/X11/fonts" ];

    services.xserver.filesSection = ''
      FontPath "${x11Fonts}/share/X11/fonts"
    '';

  };

  imports = [
    (mkRenamedOptionModule [ "fonts" "enableFontDir" ] [ "fonts" "fontDir" "enable" ])
  ];

}
