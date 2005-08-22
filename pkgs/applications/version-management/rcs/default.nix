{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rcs-5.7";
  # builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/rcs-5.7.tar;
    md5 = "f7b3f106bf87ff6344df38490f6a02c5";
  };
}
