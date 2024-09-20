{ lib
, stdenv
, fetchurl
, cmake
, kdePackages
, qt6
}:

stdenv.mkDerivation rec {
  pname = "kile";
  version = "2.9.94";

  src = fetchurl {
    url = "mirror://sourceforge/kile/kile-${version}.tar.bz2";
    sha256 = "U8Z0K9g/sJXL3ImLA/344Vq2gKgWk8yvnFB2uTrRo8o=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
    kdePackages.kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qt5compat
    kdePackages.kconfig
    kdePackages.kcrash
    kdePackages.kdbusaddons
    kdePackages.kguiaddons
    kdePackages.kiconthemes
    kdePackages.konsole
    kdePackages.kparts
    kdePackages.ktexteditor
    kdePackages.kwindowsystem
    kdePackages.okular
    kdePackages.poppler
  ];

  meta = {
    description = "User-friendly TeX/LaTeX authoring tool for the KDE desktop environment";
    homepage = "https://www.kde.org/applications/office/kile/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "kile";
  };
}
