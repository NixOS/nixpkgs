{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  addDriverRunpath,
  poppler-utils,
  libgbm,
  xvfb-run,
  fontconfig,
  freetype,
  xorg,
  python3,
  git,
}:
let
  qtPython = python3.withPackages (pkgs: with pkgs; [ pyqt5 ]);
in
stdenv.mkDerivation rec {
  pname = "seamly2d";
  version = "2025.8.4.217";

  src = fetchFromGitHub {
    owner = "FashionFreedom";
    repo = "Seamly2D";
    tag = "v${version}";
    hash = "sha256-PaGYpGZJGXPXJdfkS0siXGKxhSSdGCzDxAYdGv/lPvA=";
  };

  buildInputs = [
    libsForQt5.qtmultimedia
    git
    qtPython
    libsForQt5.qtbase
    poppler-utils
    libsForQt5.qtxmlpatterns
    libsForQt5.qtsvg
    libgbm
    freetype
    xorg.libXi
    xorg.libXrender
    xorg.libxcb
  ];

  nativeBuildInputs = [
    addDriverRunpath
    xvfb-run
    fontconfig
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
    libsForQt5.qttools
  ];

  postPatch = ''
    substituteInPlace src/app/seamly2d/mainwindowsnogui.cpp \
      --replace-fail 'define PDFTOPS "pdftops"' 'define PDFTOPS "${lib.getBin poppler-utils}/bin/pdftops"'
    substituteInPlace src/libs/vwidgets/export_format_combobox.cpp \
      --replace-fail 'define PDFTOPS "pdftops"' 'define PDFTOPS "${lib.getBin poppler-utils}/bin/pdftops"'
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

  postInstall = ''
    mv $out/share/seamly2d/* $out/share/.
    rmdir $out/share/seamly2d

    mkdir -p $out/share/mime/packages
    cp dist/debian/seamly2d.sharedmimeinfo $out/share/mime/packages/seamly2d.xml
  '';

  meta = {
    description = "Open source patternmaking software";
    homepage = "https://seamly.net/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ WhittlesJr ];
  };
}
