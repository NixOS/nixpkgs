{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2, eigen,
kdegraphics, lcms, jasper, libgphoto2, kdepimlibs, gettext, soprano, kdeedu,
liblqr1, lensfun, pkgconfig }:

stdenv.mkDerivation rec {
  name = "digikam-1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/digikam/${name}.tar.bz2";
    sha256 = "1vvzw132aw2c1z2v1zc3aqa99kvg501krr2law35ri12zkqjsvaz";
  };

  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 eigen
    lcms jasper libgphoto2 kdepimlibs gettext soprano kdeedu liblqr1 lensfun
    pkgconfig ];

  KDEDIRS=kdeedu;

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
