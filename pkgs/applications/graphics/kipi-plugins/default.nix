{
  stdenv, fetchurl,
  extra-cmake-modules,
  karchive, kconfig, ki18n, kiconthemes, kio, kservice, kwindowsystem, kxmlgui,
  libkipi, qtbase, qtsvg, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  name    = "kipi-plugins-${version}";
  version = "5.8.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/digikam/digikam-${version}.tar.xz";
    sha256 = "0vhw15bjpp18vn8h8pm8d50ddlc3shw7m9pvmh0xaad27k648jhr";
  };

  prePatch = ''
    cd extra/kipi-plugins
  '';

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
