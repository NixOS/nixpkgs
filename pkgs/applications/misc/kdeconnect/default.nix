{ stdenv
, lib
, fetchurl
, extra-cmake-modules
, kcmutils
, kconfigwidgets
, kdbusaddons
, kiconthemes
, ki18n
, knotifications
, qca-qt5
, libfakekey
, libXtst
, qtx11extras
}:

stdenv.mkDerivation rec {
  pname = "kdeconnect";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-kde-${version}.tar.xz";
    sha256 = "0w3rdldnr6md70r4ch255vk712d37vy63ml7ly2fhr4cfnk2i1ay";
  };

  buildInputs = [
    kcmutils
    kconfigwidgets
    kdbusaddons
    qca-qt5
    ki18n
    kiconthemes
    knotifications
    libfakekey
    libXtst
    qtx11extras
  ];

  nativeBuildInputs = [ extra-cmake-modules ];

  meta = {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
    homepage = https://community.kde.org/KDEConnect;
  };

}
