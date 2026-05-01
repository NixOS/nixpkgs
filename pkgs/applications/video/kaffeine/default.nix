{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  libvlc,
  libv4l,
  libx11,
  kidletime,
  kdelibs4support,
  libxscrnsaver,
  wrapQtAppsHook,
  qtx11extras,
}:

stdenv.mkDerivation rec {
  pname = "kaffeine";
  version = "2.0.19";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kaffeine";
    owner = "Multimedia";
    rev = "v${version}";
    hash = "sha256-AHyUS2vyeuWFLRXdIoy1sbssDgzz7N957vyf5rWiooI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    libvlc
    libv4l
    libx11
    kidletime
    qtx11extras
    kdelibs4support
    libxscrnsaver
  ];

  meta = {
    description = "KDE media player";
    homepage = "https://apps.kde.org/kaffeine/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.pasqui23 ];
    platforms = lib.platforms.all;
    mainProgram = "kaffeine";
  };
}
