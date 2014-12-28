{stdenv, fetchurl, flex, bison, libpcap}:

stdenv.mkDerivation rec {
  name = "daq-2.0.4";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.snort.org/downloads/snort/${name}.tar.gz";
    sha256 = "0g15kny0s6mpqfc723jxv7mgjfh45izhwcidhjzh52fd04ysm552";
  };
  
  buildInputs = [ flex bison libpcap ];
  
  meta = {
    description = "Data AcQuisition library (DAQ), for packet I/O";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
