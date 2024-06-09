{ lib, stdenv, fetchurl, libxml2, freetype, libGLU, libGL, glew
, qtbase, wrapQtAppsHook, autoPatchelfHook, python3
, cmake, libjpeg, llvmPackages }:

stdenv.mkDerivation rec {
  pname = "tulip";
  version = "5.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/auber/tulip-${version}_src.tar.gz";
    hash = "sha256-7z21WkPi1v2AGishDmXZPAedMjgXPRnpUiHTzEnc5LY=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [ libxml2 freetype glew libjpeg qtbase python3 ]
    ++ lib.optionals stdenv.isDarwin [ llvmPackages.openmp ]
    ++ lib.optionals stdenv.isLinux [ libGLU libGL ];

  qtWrapperArgs = [ ''--prefix PATH : ${lib.makeBinPath [ python3 ]}'' ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin (toString [
    # fatal error: 'Python.h' file not found
    "-I${python3}/include/${python3.libPrefix}"
    # error: format string is not a string literal (potentially insecure)
    "-Wno-format-security"
  ]);

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
    platforms = lib.platforms.all;
  };
}
