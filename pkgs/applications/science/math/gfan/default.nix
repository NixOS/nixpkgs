{stdenv, fetchurl, gmp, mpir, cddlib}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gfan";
  version = "0.6";

  src = fetchurl {
    url = "http://home.math.au.dk/jensen/software/gfan/gfan${version}.tar.gz";
    sha256 = "02d6dvzfwy0lnidfgf98052jfqwy285nfm1h5nnx7jbgic1nnpgz";
  };

  makeFlags = ''PREFIX=$(out) CC=cc CXX=c++ cddnoprefix=1'';
  buildInputs = [gmp mpir cddlib];

  meta = {
    inherit version;
    description = ''A software package for computing Gröbner fans and tropical varieties'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://home.math.au.dk/jensen/software/gfan/gfan.html;
  };
}
