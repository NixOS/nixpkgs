{ mkDerivation
, lib
, fetchurl
, cmake
, pkg-config
, extra-cmake-modules
, qtbase
, kactivities
, hunspell
, qtscript
, kross
}:
mkDerivation {

  name = "lokalize";

  nativeBuildInputs = [ pkg-config extra-cmake-modules cmake  ];

  buildInputs = [ kross qtscript hunspell kactivities qtbase ];

  meta = with lib; {
    description = "Computer-aided translation system that focuses on productivity and quality assurance";
    license = licenses.gpl2Plus;
    homepage = "https://kde.org/applications/en/development/org.kde.lokalize";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
