{ callPackage, lowPrio }:

let
  tesseract3 = callPackage ./tesseract3.nix {};
  tesseract4 = callPackage ./tesseract4.nix {};
in
{
  tesseract = tesseract3;

  tesseract_4 = lowPrio tesseract4;
}
