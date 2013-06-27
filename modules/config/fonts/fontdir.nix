{ config, pkgs, ... }:

with pkgs.lib;

let

  fontDirs = config.fonts.fonts;

  localDefs = with pkgs.builderDefs; pkgs.builderDefs.passthru.function rec {
    src = "";/* put a fetchurl here */
    buildInputs = [pkgs.xorg.mkfontdir pkgs.xorg.mkfontscale];
    inherit fontDirs;
    installPhase = fullDepEntry ("
    list='';
    for i in ${toString fontDirs} ; do
      if [ -d \$i/ ]; then
        list=\"\$list \$i\";
      fi;
    done
    list=\$(find \$list -name fonts.dir -o -name '*.ttf' -o -name '*.otf');
    fontDirs='';
    for i in \$list ; do
      fontDirs=\"\$fontDirs \$(dirname \$i)\";
    done;
    mkdir -p \$out/share/X11-fonts/;
    find \$fontDirs -type f -o -type l | while read i; do
      j=\"\${i##*/}\"
      if ! test -e \"\$out/share/X11-fonts/\${j}\"; then
        ln -s \"\$i\" \"\$out/share/X11-fonts/\${j}\";
      fi;
    done;
    cd \$out/share/X11-fonts/
    rm fonts.dir
    rm fonts.scale
    rm fonts.alias
    mkfontdir
    mkfontscale
    cat \$( find ${pkgs.xorg.fontalias}/ -name fonts.alias) >fonts.alias
  ") ["minInit" "addInputs"];
  };

  x11Fonts = with localDefs; stdenv.mkDerivation rec {
    name = "X11-fonts";
    builder = writeScript (name + "-builder")
      (textClosure localDefs
        [installPhase doForceShare doPropagate]);
  };

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

  };

}
