{
  stdenv, fetchurl,
  extra-cmake-modules,
  karchive, kconfig, ki18n, kiconthemes, kio, kservice, kwindowsystem, kxmlgui,
  libkipi, qtbase, qtsvg, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  name    = "kipi-plugins-${version}";
  version = "5.9.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/digikam/digikam-${version}.tar.xz";
    sha256 = "06qdalf2mwx2f43p3bljy3vn5bk8n3x539kha6ky2vzxvkp343b6";
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
