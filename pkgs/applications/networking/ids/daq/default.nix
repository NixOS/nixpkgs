{stdenv, fetchurl, flex, bison, libpcap}:

stdenv.mkDerivation rec {
  name = "daq-2.0.2";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.snort.org/downloads/snort/${name}.tar.gz";
    sha256 = "1a39qbm9nc05yr8llawl7mz0ny1fci4acj9c2k1h4klrqikiwpfn";
  };
  
  buildInputs = [ flex bison libpcap ];
  
  meta = {
    description = "Data AcQuisition library (DAQ), for packet I/O";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
