{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl, geoip, gperftools }:

stdenv.mkDerivation rec {
  name = "bro-2.3.1";
  
  src = fetchurl {
    url = "http://www.bro.org/downloads/release/${name}.tar.gz";
    sha256 = "0008wq20xa3z95ccjspxgx7asvny28r7qlj254zdnbax6cgd4cpz";
  };
  
  buildInputs = [ cmake flex bison openssl libpcap perl zlib file curl geoip gperftools ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "Powerful network analysis framework that is much different from the typical IDS you may know";
    homepage = http://www.bro.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
  };
}
