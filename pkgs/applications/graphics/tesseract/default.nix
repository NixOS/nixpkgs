{
  callPackage,
  lowPrio,
  Accelerate,
  CoreGraphics,
  CoreVideo,
}:

let
  base3 = callPackage ./tesseract3.nix { };
  base4 = callPackage ./tesseract4.nix { };
  base5 = callPackage ./tesseract5.nix {
    inherit Accelerate CoreGraphics CoreVideo;
  };
  languages = callPackage ./languages.nix { };
in
{
  tesseract3 = callPackage ./wrapper.nix {
    tesseractBase = base3;
    languages = languages.v3;
  };

  tesseract4 = lowPrio (
    callPackage ./wrapper.nix {
      tesseractBase = base4;
      languages = languages.v4;
    }
  );

  tesseract5 = lowPrio (
    callPackage ./wrapper.nix {
      tesseractBase = base5;
      languages = languages.v4;
    }
  );
}
