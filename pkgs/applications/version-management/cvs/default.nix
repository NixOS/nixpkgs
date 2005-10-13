{stdenv, fetchurl, vim}:

stdenv.mkDerivation {
  name = "cvs-1.12.13";

  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/non-gnu/cvs/cvs-1.12.13.tar.bz2;
    md5 = "956ab476ce276c2d19d583e227dbdbea";
  };
  buildInputs = [vim];
}
