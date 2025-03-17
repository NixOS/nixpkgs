{
  stdenv,
  lib,
  qtbase,
  wrapQtAppsHook,
  fetchFromGitHub,
  addDriverRunpath,
  poppler-utils,
  qtxmlpatterns,
  qtsvg,
  libgbm,
  xvfb-run,
  fontconfig,
  freetype,
  xorg,
  qmake,
  python3,
  qttools,
  git,
  qtmultimedia,
}:
let
  qtPython = python3.withPackages (pkgs: with pkgs; [ pyqt5 ]);
in
stdenv.mkDerivation rec {
  pname = "seamly2d";
  version = "2025.3.3.205";

  src = fetchFromGitHub {
    owner = "FashionFreedom";
    repo = "Seamly2D";
    tag = "v${version}";
    hash = "sha256-gn2qkozRlv16UdOG7k6qoF/HOT3pgJzmjAmvYm5dn+o=";
  };

  buildInputs = [
    qtmultimedia
    git
    qtPython
    qtbase
    poppler-utils
    qtxmlpatterns
    qtsvg
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
    wrapQtAppsHook
    qmake
    qttools
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
