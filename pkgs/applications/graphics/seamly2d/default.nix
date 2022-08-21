{ stdenv, lib, qtbase, wrapQtAppsHook, fetchFromGitHub,
  addOpenGLRunpath, poppler_utils, qtxmlpatterns, qtsvg, mesa, gcc, xvfb-run,
  fontconfig, freetype, xorg, ccache, qmake, python3, qttools, git
}:
with lib;
let
  qtPython = python3.withPackages (pkgs: with pkgs; [ pyqt5 ]);
in
stdenv.mkDerivation rec {
  pname = "seamly2d";
  version = "2022-08-15.0339";

  src = fetchFromGitHub {
    owner = "FashionFreedom";
    repo = "Seamly2D";
    rev = "v${version}";
    sha256 = "13jxkg84jfz8g52zwhh5jvi23wryzkavwbsfalzr9m04blj5xnik";
  };

  buildInputs = [
    git
    qtPython
    qtbase
    addOpenGLRunpath
    poppler_utils
    qtxmlpatterns
    qtsvg
    mesa
    gcc
    xvfb-run
    fontconfig
    freetype
    xorg.libXi
    xorg.libXrender
    xorg.libxcb
    ccache
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    qmake
    qttools
  ];

  postPatch = ''
    substituteInPlace common.pri \
      --replace '$$[QT_INSTALL_HEADERS]/QtXmlPatterns' '${getDev qtxmlpatterns}/include/QtXmlPatterns' \
      --replace '$$[QT_INSTALL_HEADERS]/QtSvg' '${getDev qtsvg}/include/QtSvg' \
      --replace '$$[QT_INSTALL_HEADERS]/' '${getDev qtbase}/include/' \
      --replace '$$[QT_INSTALL_HEADERS]' '${getDev qtbase}'
    substituteInPlace src/app/translations.pri \
      --replace '$$[QT_INSTALL_BINS]/$$LRELEASE' '${getDev qttools}/bin/lrelease'
    substituteInPlace src/app/seamly2d/mainwindowsnogui.cpp \
      --replace 'define PDFTOPS "pdftops"' 'define PDFTOPS "${getBin poppler_utils}/bin/pdftops"'
    substituteInPlace src/libs/vwidgets/export_format_combobox.cpp \
      --replace 'define PDFTOPS "pdftops"' 'define PDFTOPS "${getBin poppler_utils}/bin/pdftops"'
    substituteInPlace src/app/seamlyme/mapplication.cpp \
      --replace 'diagrams.rcc' '../share/diagrams.rcc'
  '';

  qmakeFlags = [
    "PREFIX=/"
    "PREFIX_LIB=/lib"
    "Seamly2D.pro"
    "-r"
    "CONFIG+=noDebugSymbols"
    "CONFIG+=no_ccache"
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/usr/share $out/
    rmdir $out/usr

    mv $out/share/seamly2d/* $out/share/.
    rmdir $out/share/seamly2d

    mkdir -p $out/share/man/man1
    gzip -9c dist/debian/seamly2d.1 > $out/share/man/man1/seamly2d.1.gz

    mkdir -p $out/share/mime/packages
    cp dist/debian/seamly2d.sharedmimeinfo $out/share/mime/packages/seamly2d.xml
  '';

  meta = {
    description = "Open source patternmaking software";
    homepage = "https://seamly.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ WhittlesJr ];
  };
}
