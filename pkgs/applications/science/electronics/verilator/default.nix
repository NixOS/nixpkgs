{ lib, stdenv, fetchFromGitHub
, perl, flex, bison, python3, autoconf
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "4.224";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kn44yWkNcOLkc79HLDTxx5zQn/vqft+hhbvsoUAKR7I=";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl ];
  nativeBuildInputs = [ flex bison python3 autoconf ];

  # these tests need some interpreter paths patched early on...
  # see https://github.com/NixOS/nix/issues/1205
  doCheck = false;
  checkTarget = "test";

  preConfigure = ''
    autoconf
  '';

  postPatch = ''
    patchShebangs \
      src/flexfix \
      src/vlcovgen
  '';

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = with licenses; [ lgpl3Only artistic2 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
