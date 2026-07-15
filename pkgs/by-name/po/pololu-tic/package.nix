{
  lib,
  stdenv,
  fetchFromGitHub,
  libusbp,
  cmake,
  pkg-config,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pololu-tic";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "pololu";
    repo = "pololu-tic-software";
    tag = finalAttrs.version;
    hash = "sha256-NqYaWWBEcq0nw4pHKpZWwbkTwnlVLB1VsC/M9zjxkHg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    libusbp
  ];

  buildInputs = [
    qt5.qtbase
  ];

  meta = {
    homepage = "https://github.com/pololu/pololu-tic-software";
    description = "Pololu Tic stepper motor controller software";
    platforms = lib.platforms.all;
    license = lib.licenses.cc-by-sa-30;
    maintainers = with lib.maintainers; [ bzizou ];
  };
})
