{ stdenv, fetchurl, qt, cmake }:

stdenv.mkDerivation rec {
  name = "speedcrunch-${version}";
  version = "0.11";

  src = fetchurl {
    url = "https://bitbucket.org/heldercorreia/speedcrunch/get/${version}.tar.gz";
    sha256 = "0phba14z9jmbmax99klbxnffwzv3awlzyhpcwr1c9lmyqnbcsnkd";
  };

  buildInputs = [cmake qt];

  dontUseCmakeBuildDir = true;

  cmakeDir = "src";

  meta = with stdenv.lib; {
    homepage    = http://speedcrunch.org;
    license     = licenses.gpl2Plus;
    description = "A fast power user calculator";
    longDescription = ''
      SpeedCrunch is a fast, high precision and powerful desktop calculator.
      Among its distinctive features are a scrollable display, up to 50 decimal
      precisions, unlimited variable storage, intelligent automatic completion
      full keyboard-friendly and more than 15 built-in math function.
    '';
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };

}
