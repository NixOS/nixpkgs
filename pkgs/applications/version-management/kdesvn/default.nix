{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, apr, aprutil, subversion, db4
, kdelibs, automoc4, phonon, kde_baseapps }:

stdenv.mkDerivation {
  name = "kdesvn-1.5.5";
  src = fetchurl {
    url = http://kdesvn.alwins-world.de/downloads/kdesvn-1.5.5.tar.bz2;
    sha256 = "02sb34p04dyd88ksxvpiffhxqwmhs3yv1wif9m8w0fly9hvy1zk7";
  };

  prePatch = ''
    sed -i -e "s|/usr|${subversion}|g" src/svnqt/cmakemodules/FindSubversion.cmake
  '';

  patches = [ ./docbook.patch ];
  

  buildInputs = [ cmake qt4 perl gettext apr aprutil subversion db4 kdelibs automoc4 phonon ];

  meta = {
    description = "KDE SVN front-end";
    license = "GPL";
    homepage = http://kdesvn.alwins-world.de;
    maintainers = [ lib.maintainers.sander ];
  };
}
