{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, apr, aprutil, subversion, db, kdelibs, expat
}:

# the homepage mentions this is the final release.
# from now on, kdesvn will be part of the official kde software distribution
stdenv.mkDerivation rec {
  name = "kdesvn-1.6.0";

  src = fetchurl rec {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/kdesvn/${name}.tar.bz2/7e6adc98ff4777a06d5752d3f2b58fa3/${name}.tar.bz2";
    sha256 = "15hg6xyx5rqldfhi1yhq5ss15y6crm2is3zqm680z0bndcj6ys05";
  };

  prePatch = ''
    sed -i -e "s|/usr|${subversion.dev}|g" src/svnqt/cmakemodules/FindSubversion.cmake
  '';

  buildInputs = [ apr aprutil subversion db kdelibs expat ];

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  meta = {
    description = "KDE SVN front-end";
    license = "GPL";
    homepage = http://kdesvn.alwins-world.de;
    maintainers = [ stdenv.lib.maintainers.sander ];
    inherit (kdelibs.meta) platforms;
  };
}
