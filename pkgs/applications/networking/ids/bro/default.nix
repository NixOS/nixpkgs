{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl
, geoip, gperftools }:

stdenv.mkDerivation rec {
  name = "bro-2.4";
  
  src = fetchurl {
    url = "http://www.bro.org/downloads/release/${name}.tar.gz";
    sha256 = "1ch8w8iakr2ajbigaad70b6mfv01s2sbdqgmrqm9q9zc1c5hs33l";
  };
  
  buildInputs = [ cmake flex bison openssl libpcap perl zlib file curl geoip
   gperftools ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "Powerful network analysis framework that is much different from the typical IDS you may know";
    homepage = http://www.bro.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
  };
}
