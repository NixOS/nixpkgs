{stdenv, fetchurl, flex, bison, libpcap, libdnet, libnfnetlink, libnetfilter_queue}:

stdenv.mkDerivation rec {
  name = "daq-2.2.2";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://snort.org/downloads/archive/snort/${name}.tar.gz";
    sha256 = "0yvzscy7vqj7s5rccza0f7p6awghfm3yaxihx1h57lqspg51in3w";
  };

  buildInputs = [ flex bison libpcap libdnet libnfnetlink libnetfilter_queue];

  configureFlags = "--enable-nfq-module=yes --with-dnet-includes=${libdnet}/includes --with-dnet-libraries=${libdnet}/lib";

  meta = {
    description = "Data AcQuisition library (DAQ), for packet I/O";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux;
  };
}
