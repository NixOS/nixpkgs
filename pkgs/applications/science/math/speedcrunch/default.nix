{ stdenv, fetchurl, qt, cmake }:

stdenv.mkDerivation rec {
  name = "speedcrunch-0.11-alpha";

  src = fetchurl {
    url = "http://speedcrunch.googlecode.com/files/${name}.tar.gz";
    sha256 = "c6d6328e0c018cd8b98a0e86fb6c49fedbab5dcc831b47fbbc1537730ff80882";
  };

  patches = [./speedcrunch-0.11-alpha-dso_linking.patch];

  buildInputs = [cmake qt];

  dontUseCmakeBuildDir = true;

  cmakeDir = "../src";

  preConfigure = ''
    mkdir -p build
    cd build
  '';

  buildFlags = "VERBOSE=1";

  meta = {
    homepage    = "http://speedcrunch.digitalfanatics.org";
    license     = "GPLv2+";
    description = "A fast power user calculator";
    longDescription = ''
      SpeedCrunch is a fast, high precision and powerful desktop calculator.
      Among its distinctive features are a scrollable display, up to 50 decimal
      precisions, unlimited variable storage, intelligent automatic completion
      full keyboard-friendly and more than 15 built-in math function.
    '';
  };

}
