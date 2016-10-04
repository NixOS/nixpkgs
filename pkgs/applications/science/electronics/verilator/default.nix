{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  name    = "verilator-${version}";
  version = "3.884";

  src = fetchurl {
    url    = "http://www.veripool.org/ftp/${name}.tgz";
    sha256 = "1j159dg7m2ych5lwglb1qq1fgqh3kwhaa1r3jx84qdisg0icln2y";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl flex bison ];

  meta = {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "http://www.veripool.org/wiki/verilator";
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
