{ stdenv, fetchurl, gettext, apr, aprutil, subversion, db4, kdelibs }:

stdenv.mkDerivation rec {
  name = "kdesvn-1.5.5";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.bz2";
    sha256 = "02sb34p04dyd88ksxvpiffhxqwmhs3yv1wif9m8w0fly9hvy1zk7";
  };

  prePatch = ''
    sed -i -e "s|/usr|${subversion}|g" src/svnqt/cmakemodules/FindSubversion.cmake
  '';

  patches = [ ./docbook.patch ./virtual_inheritance.patch ];
  

  buildInputs = [ apr aprutil subversion db4 kdelibs ];

  buildNativeInputs = [ gettext ];

  meta = {
    description = "KDE SVN front-end";
    license = "GPL";
    homepage = http://kdesvn.alwins-world.de;
    maintainers = [ stdenv.lib.maintainers.sander ];
    inherit (kdelibs.meta) platforms;
  };
}
