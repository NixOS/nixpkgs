{stdenv, fetchurl, vim}:

stdenv.mkDerivation {
  name = "cvs-1.12.13";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/cvs-1.12.13.tar.bz2;
    md5 = "956ab476ce276c2d19d583e227dbdbea";
  };
  buildInputs = [vim];
}
