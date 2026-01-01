{
  lib,
<<<<<<< HEAD
  gcc15Stdenv,
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprutils,
}:

<<<<<<< HEAD
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.6.7";
=======
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.6.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-54ltTSbI6W+qYGMchAgCR6QnC1kOdKXN6X6pJhOWxFg=";
=======
    hash = "sha256-APyQ4L05EHRbQFS1t7nXex4u+g9Sh8J70W80djOnmI4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    teams = [ lib.teams.hyprland ];
  };
})
