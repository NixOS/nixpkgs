{ stdenv, fetchurl
, perl, flex, bison
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "4.040";

  src = fetchurl {
    url    = "https://www.veripool.org/ftp/${pname}-${version}.tgz";
    sha256 = "1qy0wllsmxva3c838spxwmacxx36r3njxwhgp172m4l3829785bf";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl ];
  nativeBuildInputs = [ flex bison ];

  # these tests need some interpreter paths patched early on...
  doCheck = false;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = licenses.lgpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
