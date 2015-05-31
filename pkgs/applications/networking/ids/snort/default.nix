{stdenv, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison}:

stdenv.mkDerivation rec {
  version = "2.9.7.3";
  name = "snort-${version}";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.snort.org/downloads/snort/${name}.tar.gz";
    sha256 = "0af2dkk122wzbba336v5y9l078nrfqy7gv5yl93lkicgi0xn3hwc";
  };
  
  buildInputs = [ libpcap pcre libdnet daq zlib flex bison ];
  
  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
