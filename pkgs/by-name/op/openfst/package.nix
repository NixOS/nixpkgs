{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "openfst";
  version = "1.8.4";

  src = fetchurl {
    url = "http://www.openfst.org/twiki/pub/FST/FstDownload/${pname}-${version}.tar.gz";
    hash = "sha256-qOu7bz2S0H5nFQBYdHJRjPyHy3m5plSlqKuy0OspgBY=";
  };

  configureFlags = [
    "--enable-compact-fsts"
    "--enable-compress"
    "--enable-const-fsts"
    "--enable-far"
    "--enable-linear-fsts"
    "--enable-lookahead-fsts"
    "--enable-mpdt"
    "--enable-ngram-fsts"
    "--enable-pdt"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Library for working with finite-state transducers";
    longDescription = ''
      Library for constructing, combining, optimizing, and searching weighted finite-state transducers (FSTs).
      FSTs have key applications in speech recognition and synthesis, machine translation, optical character recognition,
      pattern matching, string processing, machine learning, information extraction and retrieval among others
    '';
    homepage = "https://www.openfst.org/twiki/bin/view/FST/WebHome";
    license = licenses.asl20;
    maintainers = [ maintainers.dfordivam ];
    platforms = platforms.unix;
  };
}
