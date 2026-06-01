{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  bison,
  flex,
  makeWrapper,
  pkg-config,
}:

stdenv.mkDerivation rec {

  pname = "intercal";
  version = "0.34";

  src = fetchurl {
    url = "http://catb.org/esr/intercal/intercal-${version}.tar.gz";
    hash = "sha256-fvYUjDUd9mhGbi3L15UXci+RwzyqORWVcTfzgzcfjVU=";
  };

  postPatch = ''
    # Workaround: https://gitlab.com/esr/intercal/-/work_items/9
    substituteInPlace src/abcessh.in --replace-fail "#ifdef HAVE_STDARG_H" "#if 1"
  '';

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    makeWrapper
    pkg-config
  ];

  # Intercal invokes gcc, so we need an explicit PATH
  postInstall = ''
    wrapProgram $out/bin/ick --suffix PATH ':' ${stdenv.cc}/bin
  '';

  meta = {
    description = "Original esoteric programming language";
    longDescription = ''
      INTERCAL, an abbreviation for "Compiler Language With No
      Pronounceable Acronym", is a famously esoterical programming
      language. It was created in 1972, by Donald R. Woods and James
      M. Lyon, with the unusual goal of creating a language with no
      similarities whatsoever to any existing programming
      languages. The language largely succeeds in this goal, apart
      from its use of an assignment statement.
    '';
    homepage = "http://www.catb.org/~esr/intercal/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
# TODO: investigate if LD_LIBRARY_PATH needs to be set
