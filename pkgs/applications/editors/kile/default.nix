{ mkDerivation
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, qtscript
, kconfig
, kcrash
, kdbusaddons
, kdelibs4support
, kguiaddons
, kiconthemes
, kinit
, khtml
, konsole
, kparts
, ktexteditor
, kwindowsystem
, okular
, poppler
}:

mkDerivation rec {
  name = "kile-2.9.93";

  src = fetchurl {
    url = "mirror://sourceforge/kile/${name}.tar.bz2";
    sha256 = "BEmSEv/LJPs6aCkUmnyuTGrV15WYXwgIANbfcviMXfA=";
  };

  nativeBuildInputs = [ extra-cmake-modules wrapGAppsHook ];

  propagatedBuildInputs = [
    kconfig
    kcrash
    kdbusaddons
    kdelibs4support
    kdoctools
    kguiaddons
    kiconthemes
    kinit
    khtml
    kparts
    ktexteditor
    kwindowsystem
    okular
    poppler
    qtscript
  ];

  propagatedUserEnvPkgs = [ konsole ];

  meta = {
    description = "User-friendly TeX/LaTeX authoring tool for the KDE desktop environment";
    homepage = "https://www.kde.org/applications/office/kile/";
    maintainers = with lib.maintainers; [ fridh ];
    license = lib.licenses.gpl2Plus;
  };
}
