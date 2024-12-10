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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "pololu";
    repo = "pololu-tic-software";
    rev = "refs/tags/${finalAttrs.version}";
    sha256 = "sha256-C/v5oaC5zZwm+j9CbFaDW+ebzHxPVb8kZLg9c0HyPbc=";
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

  meta = with lib; {
    homepage = "https://github.com/pololu/pololu-tic-software";
    description = "Pololu Tic stepper motor controller software";
    platforms = platforms.all;
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ bzizou ];
  };
})
