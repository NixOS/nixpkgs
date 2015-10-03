{ stdenv, fetchurl, python, rcs, git }:

stdenv.mkDerivation rec {
  name = "src-0.19";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "0p56g09ndbmnxxjz2rn7fq3yjx572ywj0xdim9rz5cqnx0pmr71x";
  };

  buildInputs = [ python rcs git ];

  preConfigure = "patchShebangs .";

  makeFlags = [ "prefix=$(out)" ];

  doCheck = true;

  meta = {
    description = "Simple single-file revision control";
    homepage = http://www.catb.org/~esr/src/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
