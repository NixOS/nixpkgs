{ callPackage, lowPrio, Accelerate, CoreGraphics, CoreVideo
, gcc12Stdenv }:

let
  base3 = callPackage ./tesseract3.nix { stdenv = gcc12Stdenv; };
  base4 = callPackage ./tesseract4.nix { stdenv = gcc12Stdenv; };
  base5 = callPackage ./tesseract5.nix {
    inherit Accelerate CoreGraphics CoreVideo;
    stdenv = gcc12Stdenv;
  };
  languages = callPackage ./languages.nix {
    stdenv = gcc12Stdenv;
  };
in
{
  tesseract3 = callPackage ./wrapper.nix {
    tesseractBase = base3;
    languages = languages.v3;
  };

  tesseract4 = lowPrio (callPackage ./wrapper.nix {
    tesseractBase = base4;
    languages = languages.v4;
  });

  tesseract5 = lowPrio (callPackage ./wrapper.nix {
    tesseractBase = base5;
    languages = languages.v4;
  });
}
