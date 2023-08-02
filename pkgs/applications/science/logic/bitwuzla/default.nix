{ stdenv
, fetchFromGitHub
, lib
, python3
, meson
, ninja
, git
, gmp
, gtest
, cadical
, symfpu
, kissat
, cryptominisat
, pkg-config
, writeTextDir
}:

stdenv.mkDerivation rec {
  pname = "bitwuzla";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    rev = "${version}";
    hash = "sha256-+c7fOuQUXtPq0GL/AXH4PjRQL1VDtB2RBSm2xlCtLH4=";
  };

  nativeBuildInputs = [ python3 meson ninja pkg-config git gtest ];
  buildInputs = [
    gmp.dev
    cryptominisat
  ];

  # I guess these should go in the outputs of the respective packages...
  cadical-pc = writeTextDir "cadical.pc" ''
    Name: cadical
    Version: 1.5.3
    Description: cadical
    Libs: -L${cadical.lib}/lib -lcadical
    Cflags: -I${cadical.dev}/include
  '';
  kissat-pc = writeTextDir "kissat.pc" ''
    Name: kissat
    Version: 3.0.0
    Description: kissat
    Libs: -L${kissat.lib}/lib -lkissat
    Cflags: -I${kissat.dev}/include
  '';
  symfpu-pc = writeTextDir "symfpu.pc" ''
    Name: symfpu
    Version: 0.0.1
    Description: symfpu
    Cflags: -I${symfpu}
  '';

  configurePhase = ''
    runHook preConfigure

    export PKG_CONFIG_PATH=${kissat-pc}:${symfpu-pc}:${cadical-pc}:$PKG_CONFIG_PATH
    python3 ./configure.py --shared --prefix $out
    cd build

    runHook postConfigure
  '';

  meta = with lib; {
    description = "A SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    homepage = "https://bitwuzla.github.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ symphorien ];
  };
}
