{ lib, stdenv, fetchurl
, perl, flex, bison, python3
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "4.110";

  src = fetchurl {
    url    = "https://www.veripool.org/ftp/${pname}-${version}.tgz";
    sha256 = "sha256-Rxb+AFhmGinWtZyvjnRxsu3b3tbtRO3njcHGUJTs/sw=";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl ];
  nativeBuildInputs = [ flex bison python3 ];

  # these tests need some interpreter paths patched early on...
  # see https://github.com/NixOS/nix/issues/1205
  doCheck = false;
  checkTarget = "test";

  postPatch = ''
    patchShebangs \
      src/flexfix \
      src/vlcovgen
  '';

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = licenses.lgpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
