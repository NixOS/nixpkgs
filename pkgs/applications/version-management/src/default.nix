{ stdenv, fetchurl, python, rcs, git }:

stdenv.mkDerivation rec {
  name = "src-1.11";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "07kj0ri0s0vn8s54yvkyzaag332spxs0379r718b80y31c4mgbyl";
  };

  buildInputs = [ python rcs git ];

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Simple single-file revision control";
    homepage = http://www.catb.org/~esr/src/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
