{ stdenv, fetchurl, gettext, apr, aprutil, subversion, db, kdelibs, expat }:

# the homepage mentions this is the final release.
# from now on, kdesvn will be part of the official kde software distribution
stdenv.mkDerivation rec {
  name = "kdesvn-1.6.0";

  src = fetchurl rec {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/kdesvn/${name}.tar.bz2/${md5}/${name}.tar.bz2";
    md5 = "7e6adc98ff4777a06d5752d3f2b58fa3";
  };

  prePatch = ''
    sed -i -e "s|/usr|${subversion}|g" src/svnqt/cmakemodules/FindSubversion.cmake
  '';

  buildInputs = [ apr aprutil subversion db kdelibs expat ];

  nativeBuildInputs = [ gettext ];

  meta = {
    description = "KDE SVN front-end";
    license = "GPL";
    homepage = http://kdesvn.alwins-world.de;
    maintainers = [ stdenv.lib.maintainers.sander ];
    inherit (kdelibs.meta) platforms;
  };
}
