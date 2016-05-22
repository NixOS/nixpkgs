{stdenv, fetchurl, flex, bison, libpcap, libdnet, libnfnetlink, libnetfilter_queue}:

stdenv.mkDerivation rec {
  name = "daq-2.0.6";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://snort.org/downloads/archive/snort/${name}.tar.gz";
    sha256 = "1jz7gc9n6sr677ssv61qvcxybdrmsll4z7g6hsmax2p0fc91s3ml";
  };

  buildInputs = [ flex bison libpcap libdnet libnfnetlink libnetfilter_queue];

  configureFlags = "--enable-nfq-module=yes --with-dnet-includes=${libdnet}/includes --with-dnet-libraries=${libdnet}/lib";

  meta = {
    description = "Data AcQuisition library (DAQ), for packet I/O";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
