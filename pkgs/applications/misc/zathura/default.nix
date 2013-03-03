{ callPackage, pkgs, fetchurl }:

rec {
  inherit (pkgs) stdenv;

  zathura_core = callPackage ./core { };

  zathura_pdf_poppler = callPackage ./pdf-poppler { };

  zathura_djvu = callPackage ./djvu { };

  zathura_ps = callPackage ./ps { };

  zathuraWrapper = stdenv.mkDerivation {

    inherit zathura_core;

    name = "zathura-${zathura_core.version}";

    plugins_path = stdenv.lib.makeSearchPath "lib" [
      zathura_pdf_poppler
      zathura_djvu
      zathura_ps
    ];

    icon = ./icon.xpm;

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
      license = stdenv.lib.licenses.zlib;
      platforms = stdenv.lib.platforms.linux;
      maintainers = [ stdenv.lib.maintainers.garbas stdenv.lib.maintainers.smironov ];
    };
  };
}

