{
  lib,
  stdenv,
  autoreconfHook,
  fetchurl,
  openfst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opengrm-ngram";
  version = "1.3.16";

  src = fetchurl {
    url = "http://www.openfst.org/twiki/pub/GRM/NGramDownload/ngram-${finalAttrs.version}.tar.gz";
    hash = "sha256-pcwP0VVW8H+0Y2Fsmh4WaH4whPPJlE3WyBI4VJfsES4=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openfst ];

  enableParallelBuilding = true;

  meta = {
    description = "Library to make and modify n-gram language models encoded as weighted finite-state transducers";
    homepage = "https://www.openfst.org/twiki/bin/view/GRM/NGramLibrary";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.unix;
  };
})
