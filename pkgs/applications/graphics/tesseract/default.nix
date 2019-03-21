{ callPackage, lowPrio }:

let
  base3 = callPackage ./tesseract3.nix {};
  base4 = callPackage ./tesseract4.nix {};
  languages = callPackage ./languages.nix {};
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
}
