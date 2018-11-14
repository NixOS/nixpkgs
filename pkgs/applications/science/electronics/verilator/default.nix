{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  name    = "verilator-${version}";
  version = "4.002";

  src = fetchurl {
    url    = "https://www.veripool.org/ftp/${name}.tgz";
    sha256 = "10g1814kq07a2818p0lmvacy1a6shbc0k6z16wdgas4h5x1n4f43";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl flex bison ];

  postInstall = ''
    sed -i -e '3a\#!/usr/bin/env perl' -e '1,3d' $out/bin/{verilator,verilator_coverage,verilator_profcfunc}
  '';

  meta = {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
