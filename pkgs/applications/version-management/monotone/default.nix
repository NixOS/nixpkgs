{stdenv, fetchurl, boost, zlib}:

stdenv.mkDerivation {
  name = "monotone-0.42";
  src = fetchurl {
    url = http://monotone.ca/downloads/0.42/monotone-0.42.tar.gz;
    sha256 = "0i6srfx0ps8hlgdbn0y7iy9gi33a7vpiwdm5rhxjxgvhn5j9svdr";
  };
  buildInputs = [boost zlib];
}
