{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl
, geoip, gperftools, python, swig }:

stdenv.mkDerivation rec {
  name = "bro-2.5.3";

  src = fetchurl {
    url = "http://www.bro.org/downloads/${name}.tar.gz";
    sha256 = "09b227j1c0ggihbhbyphd7lnh26mpz07z1s0h148dg6fwqagm13k";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap perl zlib curl geoip gperftools python swig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = https://www.bro.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
