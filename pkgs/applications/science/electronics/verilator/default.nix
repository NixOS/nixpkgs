{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "4.018";

  src = fetchurl {
    url    = "https://www.veripool.org/ftp/${pname}-${version}.tgz";
    sha256 = "0ih38dd8hiwgjyc6gclx8i9jlycgdlrxzz8bicm4a6yj4p0jxmcq";
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
