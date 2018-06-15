{ stdenv, fetchurl, perl, flex, bison }:

stdenv.mkDerivation rec {
  name    = "verilator-${version}";
  version = "3.922";

  src = fetchurl {
    url    = "http://www.veripool.org/ftp/${name}.tgz";
    sha256 = "1srv8d1w3mwblfydznl3frswg98i3dkylx8x18c4807wsjk8vflg";
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
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
