{ lib
, mkDerivation
, fetchurl

, cmake
, extra-cmake-modules
, reuse
, wrapGAppsHook

, baloo
, karchive
, kconfig
, kcoreaddons
, kdbusaddons
, kfilemetadata
, ki18n
, kirigami2
, kirigami-addons
, kquickcharts
, kwindowsystem
, qqc2-desktop-style
, qtbase
, qtquickcontrols2
, qtwebengine
, qtwebsockets
}:

mkDerivation rec {
  pname = "arianna";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/arianna/arianna-${version}.tar.xz";
    hash = "sha256-UZnetRo0ozBMCOoIz56qExv92uZ8dyaW5cgI835vARs=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    cmake
    reuse
    wrapGAppsHook
  ];

  buildInputs = [
    baloo
    kconfig
    kcoreaddons
    kdbusaddons
    kfilemetadata
    ki18n
    kirigami2
    kirigami-addons
    kquickcharts
    kwindowsystem
    qqc2-desktop-style
    qtbase
    qtquickcontrols2
    qtwebengine
    qtwebsockets
  ];

  doCheck = true;

  meta = with lib; {
    description = "EPub Reader for mobile devices";
    homepage = "https://invent.kde.org/graphics/arianna";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ apfelkuchen6 ];
  };
}
