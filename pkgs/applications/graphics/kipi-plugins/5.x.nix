{
  stdenv, fetchurl,
  ecm,
  karchive, kconfig, ki18n, kiconthemes, kio, kservice, kwindowsystem, kxmlgui,
  libkipi, qtbase, qtsvg, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  name    = "kipi-plugins-${version}";
  version = "5.2.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/digikam/digikam-${version}.tar.xz";
    sha256 = "0q4j7iv20cxgfsr14qwzx05wbp2zkgc7cg2pi7ibcnwba70ky96g";
  };

  prePatch = ''
    cd extra/kipi-plugins
  '';

  nativeBuildInputs = [ ecm ];
  buildInputs = [
    karchive kconfig ki18n kiconthemes kio kservice kwindowsystem kxmlgui libkipi
    qtbase qtsvg qtxmlpatterns
  ];

  meta = {
    description = "Plugins for KDE-based image applications";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    platforms = stdenv.lib.platforms.linux;
  };
}
