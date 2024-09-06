{ config, lib, pkgs, ... }:
let

  cfg = config.fonts.fontDir;

  x11Fonts = pkgs.runCommand "X11-fonts" { preferLocalBuild = true; } ''
    mkdir -p "$out/share/X11/fonts"
    font_regexp='.*\.\(ttf\|ttc\|otb\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
    find ${toString config.fonts.packages} -regex "$font_regexp" \
      -exec ln -sf -t "$out/share/X11/fonts" '{}' \;
    cd "$out/share/X11/fonts"
    ${lib.optionalString cfg.decompressFonts ''
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

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to create a directory with links to all fonts in
          {file}`/run/current-system/sw/share/X11/fonts`.
        '';
      };

      decompressFonts = lib.mkOption {
        type = lib.types.bool;
        default = config.programs.xwayland.enable;
        defaultText = lib.literalExpression "config.programs.xwayland.enable";
        description = ''
          Whether to decompress fonts in
          {file}`/run/current-system/sw/share/X11/fonts`.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ x11Fonts ];
    environment.pathsToLink = [ "/share/X11/fonts" ];

    services.xserver.filesSection = ''
      FontPath "${x11Fonts}/share/X11/fonts"
    '';

  };

  imports = [
    (lib.mkRenamedOptionModule [ "fonts" "enableFontDir" ] [ "fonts" "fontDir" "enable" ])
  ];

}
