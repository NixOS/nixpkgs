{
  lib,
  callPackage,
  stdenvNoCC,
  # Configurable options
  majorVersion ? "9",
}:

let
  sources = callPackage ./sources.nix { };
  pick = {
    "8" = sources.nv-codec-headers-8;
    "9" = sources.nv-codec-headers-9;
    "10" = sources.nv-codec-headers-10;
    "11" = sources.nv-codec-headers-11;
    "12" = sources.nv-codec-headers-12;
  }.${majorVersion};
in
stdenvNoCC.mkDerivation {
  inherit (pick) pname version src;

  makeFlags = [
    "PREFIX=$(out)"
  ];

  passthru = {
    inherit sources;
  };

  meta = {
    description = "FFmpeg version of headers for NVENC - major version ${pick.version}";
    homepage = "https://ffmpeg.org/";
    downloadPage = "https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
}
