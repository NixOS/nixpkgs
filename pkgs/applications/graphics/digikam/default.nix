{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2, eigen,
kdegraphics, lcms, jasper, libgphoto2, kdepimlibs, gettext, soprano, kdeedu,
liblqr1, lensfun, pkgconfig, qjson, libkdcraw, opencv, libkexiv2, libkipi, boost,
shared_desktop_ontologies, marble }:

stdenv.mkDerivation rec {
  name = "digikam-2.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/digikam/${name}.tar.bz2";
    sha256 = "0fyyhc26syd1d1m8jqyg2i66hwd523mh419ln8y944jkrjj6gadc";
  };

  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 eigen
    lcms jasper libgphoto2 kdepimlibs gettext soprano kdeedu liblqr1 lensfun
    pkgconfig qjson libkdcraw opencv libkexiv2 libkipi boost shared_desktop_ontologies
    marble ];

  KDEDIRS=kdeedu;

  # Make digikam find some FindXXXX.cmake
  preConfigure = ''
    cp ${qjson}/share/apps/cmake/modules/FindQJSON.cmake cmake/modules;
    cp ${marble}/share/apps/cmake/modules/FindMarble.cmake cmake/modules;
  '';

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
