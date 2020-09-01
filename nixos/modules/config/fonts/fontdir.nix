{ config, lib, pkgs, ... }:

with lib;

let

  x11Fonts = pkgs.runCommand "X11-fonts" { preferLocalBuild = true; } ''
    mkdir -p "$out/share/X11/fonts"
    font_regexp='.*\.\(ttf\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
    find ${toString config.fonts.fonts} -regex "$font_regexp" \
      -exec ln -sf -t "$out/share/X11/fonts" '{}' \;
    cd "$out/share/X11/fonts"
    ${pkgs.xorg.mkfontscale}/bin/mkfontscale
    ${pkgs.xorg.mkfontdir}/bin/mkfontdir
    cat $(find ${pkgs.xorg.fontalias}/ -name fonts.alias) >fonts.alias
  '';

in

{

  options = {

    fonts = {

      enableFontDir = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to create a directory with links to all fonts in
          <filename>/run/current-system/sw/share/X11/fonts</filename>.
        '';
      };

    };

  };

  config = mkIf config.fonts.enableFontDir {

    # This is enough to make a symlink because the xserver
    # module already links all /share/X11 paths.
    environment.systemPackages = [ x11Fonts ];

    services.xserver.filesSection = ''
      FontPath "${x11Fonts}/share/X11/fonts"
    '';

  };

}
