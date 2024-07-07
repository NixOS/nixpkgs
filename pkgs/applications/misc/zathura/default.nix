{
  config,
  pkgs,
  lib,
  useMupdf ? true,
}:

lib.makeScope pkgs.newScope (
  self:
  let
    callPackage = self.callPackage;
  in
  {
    inherit useMupdf;

    gtk = pkgs.gtk3;

    zathura_core = callPackage ./core { };

    zathura_pdf_poppler = callPackage ./pdf-poppler { };

    zathura_pdf_mupdf = callPackage ./pdf-mupdf { };

    zathura_djvu = callPackage ./djvu { };

    zathura_ps = callPackage ./ps { };

    zathura_cb = callPackage ./cb { };

    zathuraWrapper = callPackage ./wrapper.nix { };
  }
)
