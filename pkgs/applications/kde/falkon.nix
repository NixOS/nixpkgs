{
  mkDerivation, lib, stdenv,
  extra-cmake-modules,

  libpthreadstubs, libxcb, libXdmcp,
  qtsvg, qttools, qtwebengine, qtx11extras,
  qtwayland, kwallet
}:

mkDerivation {
  pname = "falkon";
  meta = with lib; {
    description = "QtWebEngine based cross-platform web browser";
    homepage    = "https://community.kde.org/Incubator/Projects/Falkon";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };

  preConfigure = ''
    export NONBLOCK_JS_DIALOGS=true
    export KDE_INTEGRATION=true
    export GNOME_INTEGRATION=false
    export FALKON_PREFIX=$out
  '';

  buildInputs = [
    libpthreadstubs libxcb libXdmcp
    qtsvg qttools qtwebengine qtx11extras
    kwallet
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  nativeBuildInputs = [
    extra-cmake-modules
  ];
}
