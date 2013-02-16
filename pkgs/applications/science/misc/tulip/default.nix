{ fetchurl, stdenv, libxml2, freetype, mesa, glew, qt4
, cmake, makeWrapper, libjpeg }:

let version = "4.1.0"; in
stdenv.mkDerivation rec {
  name = "tulip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/auber/${name}_src.tar.gz";
    sha256 = "1js1f8xdm9g2m66xbhfxa8ixzw6h4gjynxsm83p54l3i0hs3biig";
  };

  buildInputs = [ libxml2 freetype glew mesa qt4 libjpeg ];

  buildNativeInputs = [ cmake makeWrapper ];

  # FIXME: "make check" needs Docbook's DTD 4.4, among other things.
  doCheck = false;

  meta = {
    description = "A visualization framework for the analysis and visualization of relational data";

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
