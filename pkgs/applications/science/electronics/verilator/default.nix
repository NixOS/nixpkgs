{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "4.030";

  src = fetchurl {
    url    = "https://www.veripool.org/ftp/${pname}-${version}.tgz";
    sha256 = "07ldkf7xkr31n1dmx82bmzam8bvc1vsp32k76vd7yzn7r853qyky";
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
