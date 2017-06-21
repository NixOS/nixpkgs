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
}:

stdenv.mkDerivation rec {
  name = "kdeconnect-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "http://download.kde.org/stable/kdeconnect/${version}/src/kdeconnect-kde-${version}.tar.xz";
    sha256 = "0b40402adw7cqz19fh8zw70f6l7b5p400mw668n3wic4favn27r2";
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
  ];

  nativeBuildInputs = [ extra-cmake-modules ];

  meta = {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
    homepage = https://community.kde.org/KDEConnect;
  };

}
