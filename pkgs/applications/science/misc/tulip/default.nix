{ fetchurl, stdenv, libxml2, freetype, mesa, glew, qt
, autoconf, automake, libtool }:

let version = "3.4.0"; in
stdenv.mkDerivation rec {
  name = "tulip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/auber/tulip/tulip-${version}/${name}.tar.bz2";
    sha256 = "2889113f773ba539472d501fb4f45dbf5eb76e02c949dfa74c63f6f815a2baab";
  };

  patches = [ ./configure-opengl.patch ];

  preConfigure =
    '' export CPATH="${mesa}/include:${glew}/include"
       export LIBRARY_PATH="${mesa}/lib:${glew}/lib"
       export QTDIR="${qt}"
       export LDFLAGS="-lGLEW"

       rm -vf aclocal.m4 ltmain.sh
       autoreconf -fi
    '';

  buildInputs = [ libxml2 freetype glew ]
    ++ [ autoconf automake libtool ];
  propagagedBuildInputs = [ mesa qt ];

  # FIXME: "make check" needs Docbook's DTD 4.4, among other things.
  doCheck = false;

  meta = {
    description = "Tulip, a visualization framework for the analysis and visualization of relational data";

    longDescription =
      '' Tulip is an information visualization framework dedicated to the
         analysis and visualization of relational data.  Tulip aims to
         provide the developer with a complete library, supporting the design
         of interactive information visualization applications for relational
         data that can be tailored to the problems he or she is addressing.
      '';

    homepage = http://tulip.labri.fr/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
