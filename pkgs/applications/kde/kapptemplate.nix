{ lib
, mkDerivation
, fetchurl
, cmake
, extra-cmake-modules
, qtbase
, kactivities
}:
mkDerivation {

  name = "kapptemplate";

  nativeBuildInputs = [ extra-cmake-modules cmake  ];

  buildInputs = [ kactivities qtbase ];

  meta = with lib; {
    description = "KDE App Code Template Generator";
    license = licenses.gpl2;
    homepage = "https://kde.org/applications/en/development/org.kde.kapptemplate";
    maintainers = [ maintainers.shamilton ];
    platforms = platforms.linux;
  };
}
