{ callPackage
, libajantv2
, librist
, srt
, qtwayland
, ...
} @ args:

callPackage ./generic.nix (args // {
  version = "28.1.2";
  sha256 = "sha256-M5UEOtdzXBVY0UGfwWx3MsM28bJ1EcVPl8acWXWV0lg=";
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
