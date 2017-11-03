{ mkDerivation
, lib
, fetchurl
, kdoctools
, wrapGAppsHook
, extra-cmake-modules
, karchive
, kcrash
, kdbusaddons
, ki18n
, kiconthemes
, knewstuff
, knotifications
, knotifyconfig
, konsole
, kparts
, kwindowsystem
, qtx11extras
}:

let
  pname = "yakuake";
  version = "3.0.3";
in mkDerivation rec {
  name = "${pname}-${version}";

    src = fetchurl {
      url = "http://download.kde.org/stable/${pname}/${version}/src/${name}.tar.xz";
      sha256 = "ef51aa3325916d352fde17870cf706397e41105103e4c9289cc4032a1b8609a7";
    };

    buildInputs = [
      karchive
      kcrash
      kdbusaddons
      ki18n
      kiconthemes
      knewstuff
      knotifications
      knotifyconfig
      kparts
      kwindowsystem
      qtx11extras
    ];

  propagatedBuildInputs = [
    karchive
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    knewstuff
    knotifications
    knotifyconfig
    kparts
    kwindowsystem
  ];

  propagatedUserEnvPkgs = [ konsole ];

  nativeBuildInputs = [
    extra-cmake-modules kdoctools wrapGAppsHook
  ];

  meta = {
    homepage = https://yakuake.kde.org;
    description = "Quad-style terminal emulator for KDE";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
