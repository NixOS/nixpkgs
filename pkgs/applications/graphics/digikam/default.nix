{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2, eigen,
lcms, jasper, libgphoto2, kdepimlibs, gettext, soprano, libjpeg, libtiff,
liblqr1, lensfun, pkgconfig, qjson, libkdcraw, opencv, libkexiv2, libkipi, boost,
shared_desktop_ontologies, marble, mysql }:

stdenv.mkDerivation rec {
  name = "digikam-3.2.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/digikam/${name}.tar.bz2";
    sha256 = "06j858d2nvbqh0bw6m60rh1bsws06fm5vfjpwwi3zxsf5ka08wmx";
  };

  nativeBuildInputs = [ cmake automoc4 pkgconfig ];

  buildInputs = [ qt4 kdelibs phonon qimageblitz qca2 eigen lcms libjpeg libtiff
    jasper libgphoto2 kdepimlibs gettext soprano liblqr1 lensfun qjson libkdcraw
    opencv libkexiv2 libkipi boost shared_desktop_ontologies marble mysql ];

  # Make digikam find some FindXXXX.cmake
  KDEDIRS="${marble}:${qjson}";

  enableParallelBuilding = true;

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
