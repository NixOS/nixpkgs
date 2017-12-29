{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl
, geoip, gperftools, python }:

stdenv.mkDerivation rec {
  name = "bro-2.5";

  src = fetchurl {
    url = "http://www.bro.org/downloads/${name}.tar.gz";
    sha256 = "10603lwhwsmh08m5rgknbspbhd4lis71qv7z8ixacgv6sf8a40hm";
  };

  buildInputs = [ cmake flex bison openssl libpcap perl zlib file curl geoip gperftools python ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework that is much different from the typical IDS you may know";
    homepage = https://www.bro.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
