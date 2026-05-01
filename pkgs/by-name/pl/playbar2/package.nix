{
  lib,
  stdenv,
  cmake,
  libsForQt5,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "playbar2";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "jsmitar";
    repo = "PlayBar2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kC04yyt0vCsie8HGJySSiDNzkWKAGncmyOKrRx2pYkc=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.extra-cmake-modules
  ];

  buildInputs = [
    libsForQt5.plasma-framework
    libsForQt5.kwindowsystem
  ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Mpris2 Client for Plasma5";
    homepage = "https://github.com/jsmitar/PlayBar2";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pjones ];
  };
})
