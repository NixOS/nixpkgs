{stdenv, fetchurl, boost, zlib}:

stdenv.mkDerivation {
  name = "monotone-0.40";
  src = fetchurl {
    url = http://monotone.ca/downloads/0.40/monotone-0.40.tar.gz;
    sha256 = "0zs1zxvdn0m27w1830qbbh5vqk948hkpdkxwnlghszcbzz49151h";
  };
  buildInputs = [boost zlib];
}
