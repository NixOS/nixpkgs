{stdenv, fetchurl, flex, bison, libpcap, libdnet, libnfnetlink, libnetfilter_queue}:

stdenv.mkDerivation rec {
  name = "daq-2.0.5";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "mirror://sourceforge/snort/${name}.tar.gz";
    sha256 = "0vdwb0r9kdlgj4g0i0swafbc7qik0zmks17mhqji8cl7hpdva13p";
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
