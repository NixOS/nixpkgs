{ fetchurl, stdenv, libxml2, freetype, libGLU_combined, glew, qt4
, cmake, makeWrapper, libjpeg, python }:

let version = "5.1.0"; in
stdenv.mkDerivation rec {
  name = "tulip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/auber/${name}_src.tar.gz";
    sha256 = "1i70y8b39gkpxfalr9844pa3l4bnnyw5y7ngxdqibil96k2b9q9h";
  };

  buildInputs = [ libxml2 freetype glew libGLU_combined qt4 libjpeg python ];

  nativeBuildInputs = [ cmake makeWrapper ];

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

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
