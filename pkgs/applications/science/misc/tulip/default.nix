{ fetchurl, stdenv, libxml2, freetype, mesa, glew, qt4
, cmake, makeWrapper, libjpeg }:

let version = "3.7.0"; in
stdenv.mkDerivation rec {
  name = "tulip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/auber/tulip/tulip-3.7.0/${name}-src.tar.gz";
    sha256 = "150fj9pdxblvl5sby61cb2kq98r6h8yljk3vq5xizn198d3fz4jq";
  };

  buildInputs = [ libxml2 freetype glew mesa qt4 libjpeg ];

  buildNativeInputs = [ cmake makeWrapper ];

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
