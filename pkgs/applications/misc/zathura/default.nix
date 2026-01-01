{
<<<<<<< HEAD
  lib,
=======
  config,
  lib,
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  newScope,
  useMupdf ? true,
}:

lib.makeScope newScope (
  self:
  let
<<<<<<< HEAD
    inherit (self) callPackage;
=======
    callPackage = self.callPackage;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  in
  {
    inherit useMupdf;

    zathura_core = callPackage ./core { };

    zathura_pdf_poppler = callPackage ./pdf-poppler { };

    zathura_pdf_mupdf = callPackage ./pdf-mupdf { };

    zathura_djvu = callPackage ./djvu { };

    zathura_ps = callPackage ./ps { };

    zathura_cb = callPackage ./cb { };

    zathuraWrapper = callPackage ./wrapper.nix { };
  }
)
