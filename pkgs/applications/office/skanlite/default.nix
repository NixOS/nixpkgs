{ lib, mkDerivation, fetchurl, cmake, extra-cmake-modules, qtbase,
  kcoreaddons, kdoctools, ki18n, kio, kxmlgui, ktextwidgets,
  libksane
}:

mkDerivation rec {
  pname   = "skanlite";
  version = "2.2.0";

  src = fetchurl {
    url    = "mirror://kde/stable/skanlite/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "VP7MOZdUe64XIVr3r0aKIl1IPds3vjBTZzOS3N3VhOQ=";
  };

  nativeBuildInputs = [ cmake kdoctools extra-cmake-modules ];

  buildInputs = [
    qtbase
    kcoreaddons kdoctools ki18n kio kxmlgui ktextwidgets
    libksane
  ];

  meta = with lib; {
    description = "KDE simple image scanning application";
    homepage    = "https://apps.kde.org/skanlite";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ polendri ];
    platforms   = platforms.linux;
  };
}
