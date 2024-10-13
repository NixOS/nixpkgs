{ lib
, stdenv
, fetchFromGitHub
, cmake
, blas
, superlu
, suitesparse
, python3
, libintl
, libiconv
}:
let
  # this is a fork version of fetk (http://www.fetk.org/)
  # which is maintained by apbs team
  fetk = stdenv.mkDerivation (finalAttrs: {
    pname = "fetk";
    version = "1.9.3";

    src = fetchFromGitHub {
      owner = "Electrostatics";
      repo = "fetk";
      rev = "refs/tags/${finalAttrs.version}";
      hash = "sha256-uFA1JRR05cNcUGaJj9IyGNONB2hU9IOBPzOj/HucNH4=";
    };

    nativeBuildInputs = [
      cmake
    ];

    cmakeFlags = [
      "-DBLAS_LIBRARIES=${blas}/lib"
      "-DBLA_STATIC=OFF"
      "-DBUILD_SUPERLU=OFF"
    ];

    env = lib.optionalAttrs stdenv.cc.isClang {
      NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int";
    };

    buildInputs = [
      blas
      superlu
      suitesparse
    ];

    meta = with lib; {
      description = "Fork of the Finite Element ToolKit from fetk.org";
      homepage = "https://github.com/Electrostatics/FETK";
      changelog = "https://github.com/Electrostatics/FETK/releases/tag/${finalAttrs.version}";
      license = licenses.lgpl21Plus;
      maintainers = with maintainers; [ natsukium ];
      platforms = platforms.unix;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apbs";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "Electrostatics";
    repo = "apbs";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-2DnHU9hMDl4OJBaTtcRiB+6R7gAeFcuOUy7aI63A3gQ=";
  };

  postPatch = ''
    # ImportFETK.cmake downloads source and builds fetk
    substituteInPlace CMakeLists.txt \
      --replace "include(ImportFETK)" "" \
      --replace 'import_fetk(''${FETK_VERSION})' ""

    # U was removed in python 3.11 because it had no effect
    substituteInPlace tools/manip/inputgen.py \
      --replace '"rU"' '"r"'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fetk
    suitesparse
    blas
    python3
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libintl
    libiconv
  ];

  cmakeFlags = [
    "-DPYTHON_VERSION=${python3.version}"
    "-DAPBS_LIBS=mc;maloc"
    "-DCMAKE_MODULE_PATH=${fetk}/share/fetk/cmake;"
    "-DENABLE_TESTS=1"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  doCheck = true;

  meta = with lib; {
    description = "Software for biomolecular electrostatics and solvation calculations";
    mainProgram = "apbs";
    homepage = "https://www.poissonboltzmann.org/";
    changelog = "https://github.com/Electrostatics/apbs/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
