{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "diction";
  version = "1.14";

  src = fetchurl {
    url = "https://www.moria.de/~michael/comp/diction/diction-${version}.tar.gz";
    hash = "sha256-2gEvs6XLplZtI4zahpsM7NvvBFJ4DE02gQCoQEcv1/w=";
  };

  meta = {
    description = "GNU style and diction utilities";
    longDescription = ''
      Diction and style are two old standard Unix commands. Diction identifies
      wordy and commonly misused phrases. Style analyses surface
      characteristics of a document, including sentence length and other
      readability measures.
    '';
    homepage = "https://www.moria.de/~michael/comp/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
