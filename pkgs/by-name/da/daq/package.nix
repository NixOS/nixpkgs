{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  libpcap,
  libdnet,
  libnfnetlink,
  libnetfilter_queue,
}:

stdenv.mkDerivation rec {
  pname = "daq";
  version = "2.2.2";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://snort.org/downloads/archive/snort/${pname}-${version}.tar.gz";
    sha256 = "0yvzscy7vqj7s5rccza0f7p6awghfm3yaxihx1h57lqspg51in3w";
  };

  buildInputs = [
    flex
    bison
    libpcap
    libdnet
    libnfnetlink
    libnetfilter_queue
  ];

  configureFlags = [
    "--enable-nfq-module=yes"
    "--with-dnet-includes=${libdnet}/includes"
    "--with-dnet-libraries=${libdnet}/lib"
  ];

  meta = {
    description = "Data AcQuisition library (DAQ), for packet I/O";
    mainProgram = "daq-modules-config";
    homepage = "https://www.snort.org";
    maintainers = with lib.maintainers; [ aycanirican ];
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
  };
}
