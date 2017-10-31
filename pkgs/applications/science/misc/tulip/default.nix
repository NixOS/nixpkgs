{ fetchurl, stdenv, libxml2, freetype, mesa, glew, qt4
, cmake, makeWrapper, libjpeg, python }:

let version = "4.9.0"; in
stdenv.mkDerivation rec {
  name = "tulip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/auber/${name}_src.tar.gz";
    sha256 = "0phc7972brvm0v6lfk4ghq9b2b4jsj6c15xlbgnvhhcxhc99wba3";
  };

  buildInputs = [ libxml2 freetype glew mesa qt4 libjpeg python ];

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
