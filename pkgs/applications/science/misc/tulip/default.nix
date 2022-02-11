{ fetchurl, lib, stdenv, libxml2, freetype, libGLU, libGL, glew
, qtbase, wrapQtAppsHook, python3
, cmake, libjpeg }:

stdenv.mkDerivation rec {
  pname = "tulip";
  version = "5.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/auber/${pname}-${version}_src.tar.gz";
    sha256 = "1fy3nvgxv3igwc1d23zailcgigj1d0f2kkh7a5j24c0dyqz5zxmw";
  };

  buildInputs = [ libxml2 freetype glew libGLU libGL libjpeg qtbase python3 ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  qtWrapperArgs = [ ''--prefix PATH : ${lib.makeBinPath [ python3 ]}'' ];

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

    homepage = "http://tulip.labri.fr/";

    license = lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;  # arbitrary choice
  };
}
