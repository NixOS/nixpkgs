{
  lib,
  stdenv,
  fetchFromCodeberg,
  fetchpatch,
  cmake,
  ninja,

  # for passthru.tests
  audacity,
  mpd,
  normalize,
  ocamlPackages,
  streamripper,
  vlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmad";
  version = "0.16.4";

  src = fetchFromCodeberg {
    owner = "tenacityteam";
    repo = "libmad";
    tag = finalAttrs.version;
    hash = "sha256-cqwNUMa6We4eJAKtGil+GfOwrfJ6Dlo6eYUXeTDdN6Q=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    (fetchpatch {
      name = "cmake-4-compatibility.patch";
      url = "https://codeberg.org/tenacityteam/libmad/commit/326363f04e583b563f63941db3cf7f50e76aceb2.patch";
      hash = "sha256-3Yk1g1diO7klqHibaF+gqBfQJlboCVOROdorykq3oLQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  passthru.tests = {
    inherit
      audacity
      mpd
      normalize
      streamripper
      vlc
      ;
    ocaml-mad = ocamlPackages.mad;
  };

  meta = {
    homepage = "https://codeberg.org/tenacityteam/libmad";
    description = "High-quality, fixed-point MPEG audio decoder supporting MPEG-1 and MPEG-2";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
