{ config, pkgs
, useMupdf ? config.zathura.useMupdf or true
, synctexSupport ? true }:

let
  callPackage = pkgs.newScope self;

  self = rec {
    gtk = pkgs.gtk3;

    zathura_core = callPackage ./core {
      inherit synctexSupport;
    };

    zathura_cb = callPackage ./cb { };

    zathura_djvu = callPackage ./djvu { };

    zathura_pdf_mupdf = callPackage ./pdf-mupdf { };

    zathura_pdf_poppler = callPackage ./pdf-poppler { };

    zathura_ps = callPackage ./ps { };

    zathuraWrapper = callPackage ./wrapper.nix {
      plugins = [
        zathura_cb
        zathura_djvu
        zathura_ps
        (if useMupdf then zathura_pdf_mupdf else zathura_pdf_poppler)
      ];
    };
  };

in self.zathuraWrapper
