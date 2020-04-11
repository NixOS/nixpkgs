{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "4.032";

  src = fetchurl {
    url    = "https://www.veripool.org/ftp/${pname}-${version}.tgz";
    sha256 = "1l3rhgw7pk59dz7dyhcl0iygn6c9rv9bv131rfzg66asxfwbfq1s";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl flex bison ];

  meta = {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
