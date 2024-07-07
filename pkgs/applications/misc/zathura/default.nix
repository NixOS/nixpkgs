{
  config,
  lib,
  stdenv,
  newScope,
  gtk3,
  # zathura_pdf_mupdf fails to load _opj_create_decompress at runtime on Darwin (https://github.com/NixOS/nixpkgs/pull/61295#issue-277982980)
  useMupdf ? config.zathura.useMupdf or (!stdenv.isDarwin),
}:

lib.makeScope newScope (
  self:
  let
    callPackage = self.callPackage;
  in
  {
    inherit useMupdf;

    gtk = gtk3;

    zathura_core = callPackage ./core { };

    zathura_pdf_poppler = callPackage ./pdf-poppler { };

    zathura_pdf_mupdf = callPackage ./pdf-mupdf { };

    zathura_djvu = callPackage ./djvu { };

    zathura_ps = callPackage ./ps { };

    zathura_cb = callPackage ./cb { };

    zathuraWrapper = callPackage ./wrapper.nix { };
  }
)
