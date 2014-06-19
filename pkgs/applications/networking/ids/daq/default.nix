{stdenv, fetchurl, flex, bison, libpcap}:

stdenv.mkDerivation rec {
  name = "daq-2.0.0";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = http://www.snort.org/downloads/2311;
    sha256 = "0f0w5jfmx0n2sms4f2mfg984a27r7qh927vkd7fclvx9cbiwibzv";
  };
  
  buildInputs = [ flex bison libpcap ];
  
  meta = {
    description = "Data AcQuisition library (DAQ), for packet I/O";
    homepage = http://www.snort.org;
    license = stdenv.lib.licenses.gpl2;
  };
}
