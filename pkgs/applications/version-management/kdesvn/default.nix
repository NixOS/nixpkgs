{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, apr, aprutil, subversion, db4
, kdelibs, automoc4, phonon, kdebase}:

stdenv.mkDerivation {
  name = "kdesvn-1.5.5";
  src = fetchurl {
    url = http://kdesvn.alwins-world.de/downloads/kdesvn-1.5.5.tar.bz2;
    sha256 = "02sb34p04dyd88ksxvpiffhxqwmhs3yv1wif9m8w0fly9hvy1zk7";
  };

  patchPhase = ''
    sed -i -e "s|/usr|${subversion}|g" src/svnqt/cmakemodules/FindSubversion.cmake
  '';

  makeFlags = [ "VERBOSE=1" ];

  buildInputs = [ cmake qt4 perl gettext apr aprutil subversion db4 kdelibs automoc4 phonon ];

  meta = {
    description = "KDE SVN front-end";
    license = "GPL";
    homepage = http://kdesvn.alwins-world.de;
    maintainers = [ lib.maintainers.sander ];
  };
}
