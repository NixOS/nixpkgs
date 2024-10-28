{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  flex,
  cadical,
  symfpu,
  gmp,
  python3,
  gtest,
  libantlr3c,
  antlr3_4,
  boost,
  jdk,
  pythonBindings ? false,
}:

stdenv.mkDerivation rec {
  pname = "cvc5";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner  = "cvc5";
    repo   = "cvc5";
    rev    = "cvc5-${version}";
    hash  = "sha256-d5F4KwPQ1nwYJbEidQsvqyaGwEugo291SpsJE2rr558=";
  };

  pythonic = fetchFromGitHub {
    owner = "cvc5";
    repo = "cvc5_pythonic_api";
    rev = "0bb7f092113e3b933dcd61b0959f3e9be9638109";
    hash = "sha256-FfZa18v1iPN9HvKtzadbJ9N7BIDPvHDSeWevCJIVNWI=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    flex
  ];
  buildInputs = [
    cadical.dev
    symfpu
    gmp
    gtest
    libantlr3c
    antlr3_4
    boost
    jdk
    (python3.withPackages (
      ps:
      with ps;
      [
        pyparsing
        tomli
      ]
      ++ lib.optionals pythonBindings [
        scikit-build
        cython
      ]
    ))
  ];

  preConfigure = ''
    patchShebangs ./src/
  '';

  postInstall = lib.optionalString pythonBindings ''
    mkdir -p $python/lib
    mv $out/lib/python3.11/ $python/lib/.
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ] ++ lib.optional pythonBindings "python";
  cmakeBuildType = "Production";

  cmakeFlags =
    [
      "-DBUILD_SHARED_LIBS=1"
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
      "-DANTLR3_JAR=${antlr3_4}/lib/antlr/antlr-3.4-complete.jar"
    ]
    ++ lib.optionals pythonBindings [
      "-DBUILD_BINDINGS_PYTHON=1"
      "-DPYTHONIC_PATH=${pythonic}"
    ];

  doCheck = true;

  meta = with lib; {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "cvc5";
    homepage = "https://cvc5.github.io";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ shadaj ];
  };
}
