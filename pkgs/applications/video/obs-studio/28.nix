{ callPackage
, libajantv2
, librist
, srt
, qtwayland
, ...
} @ args:

callPackage ./generic.nix (args // {
  version = "28.0.3";
  sha256 = "sha256-+4H1BjEgxqkAEvRyr2Tg3wXutnMvlYQEdT5jz644fMA=";
  extraPatches = [ ./Provide-runtime-plugin-destination-as-relative-path.patch ];
  extraBuildInputs = [
    libajantv2
    librist
    srt
    qtwayland
  ];
  extraCMakeFlags = [
    "-DENABLE_JACK=ON"
  ];
})
