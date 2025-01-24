{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cln,
  gmp,
  git,
  swig,
  pkg-config,
  readline,
  libantlr3c,
  boost,
  jdk,
  python3,
  antlr3_4,
}:

stdenv.mkDerivation rec {
  pname = "cvc4";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "cvc4";
    repo = "cvc4";
    rev = version;
    sha256 = "1rhs4pvzaa1wk00czrczp58b2cxfghpsnq534m0l3snnya2958jp";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    gmp
    git
    python3.pkgs.toml
    readline
    swig
    libantlr3c
    antlr3_4
    boost
    jdk
    python3
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ cln ];
  configureFlags = [
    "--enable-language-bindings=c,c++,java"
    "--enable-gpl"
    "--with-readline"
    "--with-boost=${boost.dev}"
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ "--with-cln" ];

  prePatch = ''
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/minisat
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/bvminisat
  '';

  patches = [
    ./cvc4-bash-patsub-replacement.patch
  ];

  preConfigure = ''
    patchShebangs ./src/
  '';

  cmakeBuildType = "Production";

  meta = with lib; {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "cvc4";
    homepage = "http://cvc4.cs.stanford.edu/web/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      vbgl
      thoughtpolice
      gebner
    ];
  };
}
