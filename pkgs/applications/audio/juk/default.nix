/*

nixpkgs $ nix-build . -A pkgs.juk

FIXME playing music does not work
  WARNING: bool Phonon::FactoryPrivate::createBackend() phonon backend plugin could not be loaded

FIXME scrobbler config warning: kwallet is unavailable

*/

{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, kcoreaddons
, kwidgetsaddons
, kxmlgui
, kconfig
, kdoctools
, ki18n
, kiconthemes
, kio
, kwallet
, phonon
, taglib
}:

let

in
mkDerivation rec {
  pname = "juk";
  version = "22.08.1";

  # https://invent.kde.org/multimedia/juk
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "multimedia";
    repo = "juk";
    rev = "v${version}";
    sha256 = "sha256-a5ABeAB8bbbB8yTn85nPNZJ22BNfBjs6axHGnWvAk0Y=";
  };

  buildInputs = [
    kcoreaddons
    kiconthemes
    kconfig
    ki18n
    kdoctools
    kio
    kxmlgui
    kwallet # fix? kwallet is unavailable
    kwidgetsaddons
    phonon
    taglib
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  meta = {
    homepage = "https://apps.kde.org/juk/";
    description = "audio player, tagger and music collection manager";
    license = with lib.licenses; [ gpl2Only ];
  };
}
