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
    owner = "jsmitar";
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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "Mpris2 Client for Plasma5";
    homepage = "https://github.com/jsmitar/PlayBar2";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pjones ];
  };
}
