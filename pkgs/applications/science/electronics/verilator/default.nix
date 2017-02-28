{ stdenv, fetchurl, perl, flex_2_6_1, bison }:

stdenv.mkDerivation rec {
  name    = "verilator-${version}";
  version = "3.900";

  src = fetchurl {
    url    = "http://www.veripool.org/ftp/${name}.tgz";
    sha256 = "0yvbibcysdiw6mphda0lfs56wz6v450px2420x0hbd3rc7k53s2b";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl flex_2_6_1 bison ];

  meta = {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "http://www.veripool.org/wiki/verilator";
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
