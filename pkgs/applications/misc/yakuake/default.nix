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

mkDerivation rec {
  pname = "yakuake";
  version = "3.0.4";
  name = "${pname}-${version}";

    src = fetchurl {
      url = "http://download.kde.org/stable/${pname}/${version}/src/${name}.tar.xz";
      sha256 = "1q31p1cqhz8b2bikqjrr7fww86kaq723ib4ys2zwablfa1ybbqhh";
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
