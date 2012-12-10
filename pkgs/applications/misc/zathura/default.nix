{ callPackage, pkgs }:

rec {
  inherit (pkgs) stdenv;

  zathura_core = callPackage ./core { };

  zathura_pdf_poppler = callPackage ./pdf-poppler { };

  zathura_djvu = callPackage ./djvu { };

  zathura_ps = callPackage ./ps { };

  zathuraWrapper = stdenv.mkDerivation rec {

    name = "zathura-${zathura_core.version}";

    plugins_path = stdenv.lib.makeSearchPath "lib" [
      zathura_pdf_poppler
      zathura_djvu
      zathura_ps
    ];

    zathura = "${zathura_core}/bin/zathura";

    builder = ./builder.sh;

    meta = {
      homepage = http://pwmt.org/projects/zathura/;
      description = "A highly customizable and functional PDF viewer";
      longDescription = ''
        Zathura is a highly customizable and functional PDF viewer based on the
        poppler rendering library and the gtk+ toolkit. The idea behind zathura
        is an application that provides a minimalistic and space saving interface
        as well as an easy usage that mainly focuses on keyboard interaction.
      '';
      license = "free";
    };
  };
}

