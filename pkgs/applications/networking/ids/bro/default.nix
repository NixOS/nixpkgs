{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl, geoip, gperftools }:

stdenv.mkDerivation rec {
  name = "bro-2.1";
  
  src = fetchurl {
    url = "http://www.bro.org/downloads/release/${name}.tar.gz";
    sha256 = "1q2mm7rbgjcn01na2wm5fdfdm9pggzgljxj0n127s93fip3vg0qd";
  };
  
  buildInputs = [ cmake flex bison openssl libpcap perl zlib file curl geoip gperftools ];

  USER="something";

  enableParallelBuilding = true;
  
  meta = {
    description = "Powerful network analysis framework that is much different from the typical IDS you may know";
    homepage = http://www.bro.org/;
    license = "BSD";
  };
}
