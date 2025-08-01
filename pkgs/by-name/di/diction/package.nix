{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "diction";
  version = "1.13";

  src = fetchurl {
    url = "http://www.moria.de/~michael/diction/${pname}-${version}.tar.gz";
    sha256 = "08fi971b8qa4xycxbgb42i6b5ms3qx9zpp5hwpbxy2vypfs0wph9";
  };

  meta = {
    description = "GNU style and diction utilities";
    longDescription = ''
      Diction and style are two old standard Unix commands. Diction identifies
      wordy and commonly misused phrases. Style analyses surface
      characteristics of a document, including sentence length and other
      readability measures.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
