{ lib
, pkgs
, mkDerivation
, fetchFromGitHub
, qtquickcontrols2
, cmake
, extra-cmake-modules
, kio
, krunner
, prison
, knotifyconfig
, kidletime
, kpeople
, kdesu
, kactivities-stats
, ktexteditor
, kinit
, kunitconversion
, kitemmodels
, phonon
, polkit-qt
, polkit
, mauikit
, mauikit-filebrowsing
, bluedevil
, plasma-nm
, plasma-pa
, bluez-qt
, maui-core
, cask-server
, mauiman
, mauikit-calendar
, qtmultimedia
}:

mkDerivation rec {
  pname = "maui-shell";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-8D3rlYrqLfyDZQFRSaVlxLaEblbv8w787v8Np2aW3yc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    bluedevil
    bluez-qt
    cask-server
    kactivities-stats
    kdesu
    kidletime
    kinit
    kitemmodels
    knotifyconfig
    krunner
    kunitconversion
    kpeople
    ktexteditor
    mauikit
    mauikit-calendar
    mauikit-filebrowsing
    mauiman
    maui-core
    phonon
    plasma-nm
    plasma-pa
    polkit
    polkit-qt
    prison
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "A convergent shell for desktops, tablets, and phones";
    homepage = "https://github.com/Nitrux/maui-shell";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
