{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rcs-5.7";
  src = fetchurl {
    url = ftp://ftp.cs.purdue.edu/pub/RCS/rcs-5.7.tar;
    md5 = "f7b3f106bf87ff6344df38490f6a02c5";
  };
}
