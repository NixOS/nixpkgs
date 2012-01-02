{ fetchurl, stdenv, libxml2, freetype, mesa, glew, qt4
, cmake, makeWrapper }:

let version = "3.6.1"; in
stdenv.mkDerivation rec {
  name = "tulip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/auber/${name}-src.tar.gz";
    sha256 = "0d76zmp7gmid4lc91zz6sp4rzxlga6vfwfqhap04326r4zl4nx1q";
  };

  buildInputs = [ libxml2 freetype glew mesa qt4 ];

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
