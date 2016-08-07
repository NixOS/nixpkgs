{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl
, geoip, gperftools }:

stdenv.mkDerivation rec {
  name = "bro-2.4.1";

  src = fetchurl {
    url = "http://www.bro.org/downloads/release/${name}.tar.gz";
    sha256 = "1xn8qwgnxihlr4lmg7kz2vqjk46aqgwc8878pbv30ih2lmrrdffq";
  };

  buildInputs = [ cmake flex bison openssl libpcap perl zlib file curl geoip gperftools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework that is much different from the typical IDS you may know";
    homepage = http://www.bro.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
