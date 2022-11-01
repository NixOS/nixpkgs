{ lib, stdenv, fetchFromGitHub
, perl, flex, bison, python3, autoconf
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.002";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RNoKAEF7zl+WqqbxGP/VvdQqQP8VI3hoQku3b/g0XpU=";
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
