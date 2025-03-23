{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  SDL2,
  wxGTK32,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sound-of-sorting";
  version = "0.6.5-unstable-2022-10-12";

  src = fetchFromGitHub {
    owner = "bingmann";
    repo = "sound-of-sorting";
    rev = "5cfcaf752593c8cbcf52555dd22745599a7d8b1b";
    hash = "sha256-cBrTvFoz6WZIsh5qPPiWxQ338Z0OfcIefiI8CZF6nn8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/freebsd/freebsd-ports/raw/31ec0266e31910c16b0f69e16a2a693aae20abdf/math/sound-of-sorting/files/patch-src_SortAlgo.cpp";
      extraPrefix = "";
      hash = "sha256-mOo3GsEZ8r8p9ROoel2TO9Z4yF5SmCN0/fUn/2qUKAo=";
    })
    (fetchpatch {
      url = "https://github.com/freebsd/freebsd-ports/raw/31ec0266e31910c16b0f69e16a2a693aae20abdf/math/sound-of-sorting/files/patch-src_SortAlgo.h";
      extraPrefix = "";
      hash = "sha256-NNSPs0gT6ndeMQWHLHAwLR5nMQGP880Qd6kulDYJYF0=";
    })
    (fetchpatch {
      url = "https://github.com/freebsd/freebsd-ports/raw/31ec0266e31910c16b0f69e16a2a693aae20abdf/math/sound-of-sorting/files/patch-src_SortArray.cpp";
      extraPrefix = "";
      hash = "sha256-WxqwcZ2L9HPG4QNf1Xi624aKTM3cRBWN+W00htcIJ5k=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wxGTK32
    SDL2
  ];

  meta = {
    description = "Audibilization and Visualization of Sorting Algorithms";
    homepage = "https://panthema.net/2013/sound-of-sorting/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "sound-of-sorting";
    maintainers = with lib.maintainers; [ ];
    inherit (SDL2.meta) platforms;
  };
})
