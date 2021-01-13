{ lib, stdenv, fetchurl
, perl, flex, bison, python3
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "4.108";

  src = fetchurl {
    url    = "https://www.veripool.org/ftp/${pname}-${version}.tgz";
    sha256 = "00i7am41w9v4smhl64z7s95wdb55f684y89mc0hbc07j1ggc33lf";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl python3 ];
  nativeBuildInputs = [ flex bison ];

  # these tests need some interpreter paths patched early on...
  # see https://github.com/NixOS/nix/issues/1205
  doCheck = false;
  checkTarget = "test";

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = licenses.lgpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
