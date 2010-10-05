{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2,
kdegraphics, kdepimlibs, libxml2, libxslt, gettext, opencv, libgpod}:

stdenv.mkDerivation rec {
  name = "kipi-plugins-1.4.0";

  src = fetchurl { 
    url = "mirror://sourceforge/kipi/${name}.tar.bz2";
    sha256 = "1ybxhp4rs6c5xlrs0q765vrx4mvw4k0kq6n42dyk3kxvmcb9iq34";
  };

  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 kdepimlibs 
    libxml2 libxslt gettext opencv libgpod ];

  KDEDIRS = kdegraphics;

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.kipi-plugins.org;
    inherit (kdelibs.meta) platforms;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
  };
}
