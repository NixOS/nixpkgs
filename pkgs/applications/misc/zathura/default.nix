{ callPackage, lib, pkgs, fetchurl, stdenv, useMupdf, synctexSupport ? true }:

rec {
  inherit stdenv;

  icon = ./icon.xpm;

  zathura_core = callPackage ./core {
    gtk = pkgs.gtk3;
    zathura_icon = icon;
    inherit synctexSupport;
  };

  zathura_pdf_poppler = callPackage ./pdf-poppler { };

  zathura_pdf_mupdf = callPackage ./pdf-mupdf {
    gtk = pkgs.gtk3;
  };

  zathura_djvu = callPackage ./djvu {
    gtk = pkgs.gtk3;
  };

  zathura_ps = callPackage ./ps {
    gtk = pkgs.gtk3;
  };

  zathuraWrapper = stdenv.mkDerivation {

    inherit zathura_core icon;

    name = "zathura-${zathura_core.version}";

    plugins_path = stdenv.lib.makeLibraryPath [
      zathura_djvu
      zathura_ps
      (if useMupdf then zathura_pdf_mupdf else zathura_pdf_poppler)
    ];

    builder = ./builder.sh;

    preferLocalBuild = true;

    meta = with lib; {
      homepage = http://pwmt.org/projects/zathura/;
      description = "A highly customizable and functional PDF viewer";
      longDescription = ''
        Zathura is a highly customizable and functional PDF viewer based on the
        poppler rendering library and the gtk+ toolkit. The idea behind zathura
        is an application that provides a minimalistic and space saving interface
        as well as an easy usage that mainly focuses on keyboard interaction.
      '';
      license = licenses.zlib;
      platforms = platforms.linux;
      maintainers = with maintainers;[ garbas smironov ];
    };
  };
}

