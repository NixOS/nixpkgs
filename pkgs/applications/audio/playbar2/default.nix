{
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  plasma-framework,
  kwindowsystem,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "playbar2";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "audoban";
    repo = "PlayBar2";
    rev = "v${version}";
    sha256 = "0iv2m4flgaz2r0k7f6l0ca8p6cw8j8j2gin1gci2pg3l5g5khbch";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    plasma-framework
    kwindowsystem
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Mpris2 Client for Plasma5";
    homepage = "https://github.com/audoban/PlayBar2";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pjones ];
  };
}
