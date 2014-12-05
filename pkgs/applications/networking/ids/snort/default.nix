{stdenv, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison}:

stdenv.mkDerivation rec {
  name = "snort-2.9.7.0";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.snort.org/downloads/snort/${name}.tar.gz";
    sha256 = "16z4mi7bri7ygvc0j4hhl2pgcw6xwxah1h3wk5vpy2yj8pmayf4p";
  };
  
  buildInputs = [ libpcap pcre libdnet daq zlib flex bison ];
  
  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
