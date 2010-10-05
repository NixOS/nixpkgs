{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2, eigen,
kdegraphics, lcms, jasper, libgphoto2, kdepimlibs, gettext, soprano, kdeedu,
liblqr1, lensfun, pkgconfig }:

stdenv.mkDerivation rec {
  name = "digikam-1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/digikam/${name}.tar.bz2";
    sha256 = "1fky4jkji9fkhzzvw7wic6xy7vkj9g39hx1xm76qxxq8i2nzlynk";
  };

  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 eigen
    lcms jasper libgphoto2 kdepimlibs gettext soprano kdeedu liblqr1 lensfun
    pkgconfig ];

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
