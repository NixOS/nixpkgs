{stdenv, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison}:

stdenv.mkDerivation rec {
  name = "snort-2.9.4.6";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = http://www.snort.org/downloads/2320;
    sha256 = "1g5kn36l67a5m95h2shqwqbbjb6rgl3sf1bciakal2l4n6857ang";
  };
  
  buildInputs = [ libpcap pcre libdnet daq zlib flex bison ];
  
  meta = {
    description = "Snort is an open source network intrusion prevention and detection system (IDS/IPS)";
    homepage = http://www.snort.org;
    license = stdenv.lib.licenses.gpl2;
  };
}
