{ config, pkgs
# zathura_pdf_mupdf fails to load _opj_create_decompress at runtime on Darwin (https://github.com/NixOS/nixpkgs/pull/61295#issue-277982980)
, useMupdf ? config.zathura.useMupdf or (!pkgs.stdenv.isDarwin)
, synctexSupport ? true }:

let
  callPackage = pkgs.newScope self;

  self = rec {
    gtk = pkgs.gtk3;

    zathura_core = callPackage ./core {
      inherit synctexSupport;
    };

    zathura_pdf_poppler = callPackage ./pdf-poppler { };

    zathura_pdf_mupdf = callPackage ./pdf-mupdf { };

    zathura_djvu = callPackage ./djvu { };

    zathura_ps = callPackage ./ps { };

    zathura_cb = callPackage ./cb { };

    zathuraWrapper = callPackage ./wrapper.nix {
      plugins = [
        zathura_djvu
        zathura_ps
        zathura_cb
        (if useMupdf then zathura_pdf_mupdf else zathura_pdf_poppler)
      ];
    };
  };

in self.zathuraWrapper
