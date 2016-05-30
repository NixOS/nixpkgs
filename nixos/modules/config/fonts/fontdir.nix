{ config, lib, pkgs, ... }:

with lib;

let

  x11Fonts = pkgs.runCommand "X11-fonts" { } ''
    mkdir -p "$out/share/X11-fonts"
    find ${toString config.fonts.fonts} \
      \( -name fonts.dir -o -name '*.ttf' -o -name '*.otf' \) \
      -exec ln -sf -t "$out/share/X11-fonts" '{}' \;
    cd "$out/share/X11-fonts"
    rm -f fonts.dir fonts.scale fonts.alias
    ${pkgs.xorg.mkfontdir}/bin/mkfontdir
    ${pkgs.xorg.mkfontscale}/bin/mkfontscale
    cat $(find ${pkgs.xorg.fontalias}/ -name fonts.alias) >fonts.alias
  '';

in

{

  options = {

    fonts = {

      enableFontDir = mkOption {
        default = false;
        description = ''
          Whether to create a directory with links to all fonts in
          <filename>/run/current-system/sw/share/X11-fonts</filename>.
        '';
      };

    };

  };

  config = mkIf config.fonts.enableFontDir {

    environment.systemPackages = [ x11Fonts ];

    environment.pathsToLink = [ "/share/X11-fonts" ];

  };

}
