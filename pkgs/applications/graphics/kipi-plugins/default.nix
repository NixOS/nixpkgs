{
  stdenv, fetchurl,
  extra-cmake-modules,
  karchive, kconfig, ki18n, kiconthemes, kio, kservice, kwindowsystem, kxmlgui,
  libkipi, qtbase, qtsvg, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  pname    = "kipi-plugins";
  version = "5.9.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0hjm05nkz0w926sn4lav5258rda6zkd6gfnqd8hh3fa2q0dd7cq4";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive kconfig ki18n kiconthemes kio kservice kwindowsystem kxmlgui libkipi
    qtbase qtsvg qtxmlpatterns
  ];

  meta = {
    description = "Plugins for KDE-based image applications";
    license = stdenv.lib.licenses.gpl2;
    homepage = https://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    platforms = stdenv.lib.platforms.linux;
  };
}
