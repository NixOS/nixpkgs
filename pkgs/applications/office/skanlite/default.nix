{ stdenv, mkDerivation, fetchurl, cmake, extra-cmake-modules, qtbase,
  kcoreaddons, kdoctools, ki18n, kio, kxmlgui, ktextwidgets,
  libksane
}:

let
  minorVersion = "2.2";
in mkDerivation rec {
  name = "skanlite-2.2.0";

  src = fetchurl {
    url    = "mirror://kde/stable/skanlite/${minorVersion}/${name}.tar.xz";
    sha256 = "VP7MOZdUe64XIVr3r0aKIl1IPds3vjBTZzOS3N3VhOQ=";
  };

  nativeBuildInputs = [ cmake kdoctools extra-cmake-modules ];

  buildInputs = [
    qtbase
    kcoreaddons kdoctools ki18n kio kxmlgui ktextwidgets
    libksane
  ];

  meta = with stdenv.lib; {
    description = "KDE simple image scanning application";
    homepage    = "http://www.kde.org/applications/graphics/skanlite/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pshendry ];
    platforms   = platforms.linux;
  };
}
