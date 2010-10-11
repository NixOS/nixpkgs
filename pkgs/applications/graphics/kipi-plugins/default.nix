{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2,
kdegraphics, kdepimlibs, libxml2, libxslt, gettext, opencv, libgpod, gtk }:

stdenv.mkDerivation rec {
  name = "kipi-plugins-1.5.0";

  src = fetchurl { 
    url = "mirror://sourceforge/kipi/${name}.tar.bz2";
    sha256 = "1wsqh0lbsqyzdfmb9f53bmmypw00n80p62ym4pnxb8w0zwlhbkbw";
  };

  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 kdepimlibs 
    libxml2 libxslt gettext opencv libgpod gtk ];

  KDEDIRS = kdegraphics;

  patches = [ ./find-gdk.patch ];

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.kipi-plugins.org;
    inherit (kdelibs.meta) platforms;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
  };
}
