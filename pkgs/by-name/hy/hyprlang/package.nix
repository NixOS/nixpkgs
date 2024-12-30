{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprutils,
}:

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oj8V4kvzor5AOStzj4/B4W1ZIObAPxT9K4NfXx7dyKE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprutils
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/hyprwm/hyprlang";
    description = "Official implementation library for the hypr config language";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      iogamaster
      fufexan
    ];
  };
})
