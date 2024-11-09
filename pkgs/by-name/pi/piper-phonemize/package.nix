{ lib
, stdenv
, fetchFromGitHub
, fetchpatch

# build
, cmake
, pkg-config

# runtime
, espeak-ng
, onnxruntime
}:

let
  espeak-ng' = espeak-ng.overrideAttrs (oldAttrs: {
    version = "1.52-dev";
    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "espeak-ng";
      rev = "0f65aa301e0d6bae5e172cc74197d32a6182200f";
      hash = "sha256-2V0D3QO+v9OqffpNmwJQd3NIBd/IFeLkjaJ3Y0HHw7E=";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/espeak-ng/espeak-ng/commit/497c6217d696c1190c3e8b992ff7b9110eb3bedd.patch";
        hash = "sha256-KfzqnRyQfz6nuMKnsHoUzb9rn9h/Pg54mupW1Cr+Zx0=";
      })
      ./espeak-mbrola.patch
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "piper-phonemize";
  version = "2023.11.14-4";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "piper-phonemize";
    rev = "refs/tags/${version}";
    hash = "sha256-pj1DZUhy3XWGn+wNtxKKDWET9gsfofEB0NZ+EEQz9q0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DONNXRUNTIME_DIR=${onnxruntime.dev}"
    "-DESPEAK_NG_DIR=${espeak-ng'}"
  ];

  buildInputs = [
    espeak-ng'
    onnxruntime
  ];

  passthru = {
    espeak-ng = espeak-ng';
  };

  meta = with lib; {
    description = "C++ library for converting text to phonemes for Piper";
    homepage = "https://github.com/rhasspy/piper-phonemize";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
