{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-502X0Q0fhN6tJK7iEUA8CghONKSatW/Mqj4Wappd++0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprlang";
    description = "The official implementation library for the hypr config language";
    license = licenses.lgpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      iogamaster
      fufexan
    ];
  };
})
