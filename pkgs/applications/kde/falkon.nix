{
  stdenv,
  mkDerivation,
  lib,
  cmake,
  extra-cmake-modules,
  pkg-config,
  libpthreadstubs,
  libxcb,
  libXdmcp,
  qtsvg,
  qttools,
  qtwebengine,
  qtx11extras,
  qtwayland,
  wrapQtAppsHook,
  kwallet,
  kpurpose,
  karchive,
  kio,
}:

mkDerivation rec {
  pname = "falkon";

  preConfigure = ''
    export NONBLOCK_JS_DIALOGS=true
    export KDE_INTEGRATION=true
    export GNOME_INTEGRATION=false
    export FALKON_PREFIX=$out
  '';

  buildInputs = [
    libpthreadstubs
    libxcb
    libXdmcp
    qtsvg
    qttools
    qtwebengine
    qtx11extras
    kwallet
    kpurpose
    karchive
    kio
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ qtwayland ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  meta = {
    description = "QtWebEngine based cross-platform web browser";
    mainProgram = "falkon";
    homepage = "https://www.falkon.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
}
