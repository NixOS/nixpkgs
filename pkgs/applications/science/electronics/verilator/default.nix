{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  name    = "verilator-${version}";
  version = "3.874";

  src = fetchurl {
    url    = "http://www.veripool.org/ftp/${name}.tgz";
    sha256 = "070binwp0jnashi6w45km26vrn6200b8hdg4179lcqyzdxi8c06j";
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
