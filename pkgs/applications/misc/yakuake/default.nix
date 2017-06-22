{ kdeDerivation
, lib
, fetchurl
, kdoctools
, kdeWrapper
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
}:

let
  unwrapped = let
    pname = "yakuake";
    version = "3.0.3";
  in kdeDerivation rec {
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
    ];

    nativeBuildInputs = [
      extra-cmake-modules kdoctools
    ];

    meta = {
      homepage = https://yakuake.kde.org;
      description = "Quad-style terminal emulator for KDE";
      maintainers = with lib.maintainers; [ fridh ];
    };
  };


in
kdeWrapper
{
  inherit unwrapped;
  targets = [ "bin/yakuake" ];
  paths = [ konsole.unwrapped ];
}
