{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "batik-1.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://tarballs.nixos.org/batik-1.6.zip;
    sha256 = "0cf15dspmzcnfda8w5lbsdx28m4v2rpq1dv5zx0r0n99ihqd1sh6";
  };

  buildInputs = [unzip];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
