{ lib, stdenv, fetchFromGitHub
, perl, flex, bison, python3, autoconf
, which, cmake, help2man
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.006";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PA8hbE6XECapuaO5YcgEodOoxSDqpMucdijJBBb7fZg=";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl ];
  nativeBuildInputs = [ flex bison python3 autoconf help2man ];
  nativeCheckInputs = [ which ];

  doCheck = stdenv.isLinux; # darwin tests are broken for now...
  checkTarget = "test";

  preConfigure = "autoconf";

  postPatch = ''
    patchShebangs bin/* src/{flexfix,vlcovgen} test_regress/{driver.pl,t/*.pl}
  '';

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = with licenses; [ lgpl3Only artistic2 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
