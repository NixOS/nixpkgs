{ cmake
, fetchFromGitHub
, hicolor-icon-theme
, lib
, libsForQt5
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "2048-qt";
  version = "0.1.7";
  src = fetchFromGitHub {
    owner = "OpenOrphanage";
    repo = "2048-Qt";
    rev = "v${version}";
    hash = "sha256-Un1A5kSFKXtA3Z1YJwG2g6EgT3lB7mI5c44PpdmPRls=";
  };

  buildInputs = with libsForQt5.qt5; [
    hicolor-icon-theme
    qtquickcontrols2
    qttools
    qtbase
  ];

  nativeBuildInputs = with libsForQt5.qt5; [
    qmake
    wrapQtAppsHook
  ];

  preConfigure = ''
    sed -i 's|/opt/$${TARGET}/bin|'"`echo $out`"'/bin|' deployment.pri
  '';

  postInstall = ''
    install -D -m644 res/icons/16x16/apps/${pname}.png "$out/share/icons/hicolor/16x16/apps/${pname}.png"
    install -D -m644 res/icons/32x32/apps/${pname}.png "$out/share/icons/hicolor/32x32/apps/${pname}.png"
    install -D -m644 res/icons/48x48/apps/${pname}.png "$out/share/icons/hicolor/48x48/apps/${pname}.png"
    install -D -m644 res/icons/256x256/apps/${pname}.png "$out/share/icons/hicolor/256x256/apps/${pname}.png"
    install -D -m644 res/icons/scalable/apps/${pname}.svg "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
    install -D -m644 res/${pname}.desktop "$out/share/applications/${pname}.desktop"
    install -D -m644 res/man/${pname}.6 "$out/share/man/man6/${pname}.6"
  '';

  meta = with lib; {
    homepage = "https://github.com/OpenOrphanage/2048-Qt";
    description = "The 2048 number game implemented in Qt";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ raspher ];
  };
}
