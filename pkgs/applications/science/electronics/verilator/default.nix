{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  name    = "verilator-${version}";
  version = "3.872";

  src = fetchurl {
    url    = "http://www.veripool.org/ftp/${name}.tgz";
    sha256 = "113ha7vy6lsi9zygiy3rnsd3dhi5y8lkfsfrh0nwzady7147l2yh";
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
