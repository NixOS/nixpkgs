{stdenv, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison}:

stdenv.mkDerivation rec {
  version = "2.9.7.2";
  name = "snort-${version}";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.snort.org/downloads/snort/${name}.tar.gz";
    sha256 = "1gmlrh9ygpd5h6nnrr4090wk5n2yq2yrvwi7q6xbm6lxj4rcamyv";
  };
  
  buildInputs = [ libpcap pcre libdnet daq zlib flex bison ];
  
  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
