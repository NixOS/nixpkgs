{ lib, stdenv, fetchFromGitHub
, perl, flex, bison, python3, autoconf
, which, cmake
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
  checkInputs = [ which ];

  doCheck = stdenv.isLinux; # darwin tests are broken for now...
  checkTarget = "test";

  preConfigure = "autoconf";

  preCheck = ''
    patchShebangs \
      src/flexfix \
      src/vlcovgen \
      bin/verilator \
      bin/verilator_coverage \
      test_regress/driver.pl \
      test_regress/t/*.pl
  '';

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = with licenses; [ lgpl3Only artistic2 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
