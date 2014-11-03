{stdenv, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison}:

stdenv.mkDerivation rec {
  name = "snort-2.9.6.2";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.snort.org/downloads/snort/${name}.tar.gz";
    sha256 = "0xsxbd5h701ncnhn9sf7zkmzravlqhn1182whinphfjjw72py7cf";
  };
  
  buildInputs = [ libpcap pcre libdnet daq zlib flex bison ];
  
  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
