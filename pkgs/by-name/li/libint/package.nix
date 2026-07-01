{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  gmpxx,
  boost,
  eigen_5,
  gfortran,
  cmake,
  ninja,
  enableFMA ? stdenv.hostPlatform.fmaSupport,
  enableFortran ? true,
  enableSSE ? (!enableFortran) && stdenv.hostPlatform.isx86_64,

  # Maximum angular momentum of basis functions
  # 7 is required for def2/J auxiliary basis on 3d metals upwards
  maxAm ? 7,

  # ERI derivative order for 4-, 3- and 2-centre ERIs.
  # 2nd derivatives are defaults and allow gradients Hessians with density fitting
  # Setting them to zero disables derivatives.
  eriDeriv ? 2,
  eri3Deriv ? 2,
  eri2Deriv ? 2,

  # Angular momentum for derivatives of ERIs. Takes a list of length $DERIV_ORD+1.
  # Starting from index 0, each index i specifies the supported angular momentum
  # for the derivative order i, e.g. [6,5,4] supports ERIs for l=6, their first
  # derivatives for l=5 and their second derivatives for l=4.
  eriAm ? (builtins.genList (i: maxAm - 1 - i) (eriDeriv + 1)),
  eri3Am ? (builtins.genList (i: maxAm - i) (eri3Deriv + 1)),
  eri2Am ? (builtins.genList (i: maxAm - i) (eri2Deriv + 1)),

  # Same as above for optimised code. Higher optimisations take a long time.
  eriOptAm ? (builtins.genList (i: maxAm - 3 - i) (eriDeriv + 1)),
  eri3OptAm ? (builtins.genList (i: maxAm - 3 - i) (eri3Deriv + 1)),
  eri2OptAm ? (builtins.genList (i: maxAm - 3 - i) (eri2Deriv + 1)),

  # One-Electron integrals of all kinds including multipole integrals.
  # Libint does not build them and their derivatives by default.
  enableOneBody ? false,
  oneBodyDerivOrd ? 2,
  multipoleOrd ? 4, # Maximum order of multipole integrals, 4=octopoles

  # Whether to enable generic code if angular momentum is unsupported
  enableGeneric ? true,

  # Support integrals over contracted Gaussian
  enableContracted ? true,

  # Spherical harmonics/Cartesian orbital conventions
  cartGaussOrd ? "standard", # Ordering of Cartesian basis functions, "standard" is CCA
  shGaussOrd ? "standard", # Ordering of spherical harmonic basis functions. "standard" is -l to +l, "guassian" is 0, 1, -1, 2, -2, ...
  shellSet ? "standard",
  eri3PureSh ? false, # Transformation of 3-centre ERIs into spherical harmonics
  eri2PureSh ? false, # Transformation of 2-centre ERIs into spherical harmonics
}:

# Check that Fortran bindings are not used together with SIMD real type
assert (if enableFortran then !enableSSE else true);

# Check that a possible angular momentum for basis functions is used
assert (maxAm >= 1 && maxAm <= 8);

# Check for valid derivative order in ERIs
assert (eriDeriv >= 0 && eriDeriv <= 4);
assert (eri2Deriv >= 0 && eri2Deriv <= 4);
assert (eri3Deriv >= 0 && eri3Deriv <= 4);

# Ensure valid arguments for generated angular momenta in ERI derivatives are used.
assert (
  builtins.length eriAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (map (a: a <= maxAm && a >= 0) eriAm)
);
assert (
  builtins.length eri3Am == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (map (a: a <= maxAm && a >= 0) eri3Am)
);
assert (
  builtins.length eri2Am == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (map (a: a <= maxAm && a >= 0) eri2Am)
);

# Ensure valid arguments for generated angular momenta in optimised ERI derivatives are used.
assert (
  builtins.length eriOptAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (map (a: a <= maxAm && a >= 0) eriOptAm)
);
assert (
  builtins.length eri3OptAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (map (a: a <= maxAm && a >= 0) eri3OptAm)
);
assert (
  builtins.length eri2OptAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (map (a: a <= maxAm && a >= 0) eri2OptAm)
);

# Ensure a valid derivative order for one-electron integrals
assert (oneBodyDerivOrd >= 0 && oneBodyDerivOrd <= 4);

# Check that valid basis shell orders are used, see https://github.com/evaleev/libint/wiki
assert (
  builtins.elem cartGaussOrd [
    "standard"
    "intv3"
    "gamess"
    "orca"
    "bagel"
  ]
);
assert (
  builtins.elem shGaussOrd [
    "standard"
    "gaussian"
  ]
);
assert (
  builtins.elem shellSet [
    "standard"
    "orca"
  ]
);

stdenv.mkDerivation (finalAttrs: {
  pname = "libint";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "evaleev";
    repo = "libint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vXlHnQzmyDImyvO+Fo8v1ux6EXlw7PAdfXDXL+UyNdw=";
  };

  nativeBuildInputs = [
    cmake
    gmpxx
    python3
    ninja
  ]
  ++ lib.optional enableFortran gfortran;

  buildInputs = [
    boost
    eigen_5
  ];

  cmakeFlags = [
    "-DLIBINT2_MAX_AM=${toString maxAm}"
    "-DLIBINT2_ERI_MAX_AM=${lib.concatStringsSep ";" (map toString eriAm)}"
    "-DLIBINT2_ERI2_MAX_AM=${lib.concatStringsSep ";" (map toString eri2Am)}"
    "-DLIBINT2_ERI3_MAX_AM=${lib.concatStringsSep ";" (map toString eri3Am)}"
    "-DLIBINT2_ERI_OPT_AM=${lib.concatStringsSep ";" (map toString eriOptAm)}"
    "-DLIBINT2_ERI2_OPT_AM=${lib.concatStringsSep ";" (map toString eri2OptAm)}"
    "-DLIBINT2_ERI3_OPT_AM=${lib.concatStringsSep ";" (map toString eri3OptAm)}"
    "-DLIBINT2_CARTGAUSS_ORDERING=${cartGaussOrd}"
    "-DLIBINT2_SHGAUSS_ORDERING=${shGaussOrd}"
    "-DLIBINT2_SHELL_SET=${shellSet}"
    "-DLIBINT2_SHGAUSS_ORDERING=${shGaussOrd}"
  ]
  ++ lib.optional enableFMA "-DLIBINT2_GENERATE_FMA=ON"
  ++ lib.optional (eriDeriv > 0) "-DLIBINT2_ENABLE_ERI=${toString eriDeriv}"
  ++ lib.optional (eri2Deriv > 0) "-DLIBINT2_ENABLE_ERI2=${toString eri2Deriv}"
  ++ lib.optional (eri3Deriv > 0) "-DLIBINT2_ENABLE_ERI3=${toString eri3Deriv}"
  ++ lib.optional enableOneBody "-DLIBINT2_ENABLE_ONEBODY=${toString oneBodyDerivOrd}"
  ++ lib.optional (multipoleOrd > 0) "-DLIBINT2_MULTIPOLE_MAX_ORDER=${toString multipoleOrd}"
  ++ lib.optional enableGeneric "-DLIBINT2_ENABLE_GENERIC_CODE=ON"
  ++ lib.optional (!enableContracted) "-DLIBINT2_CONTRACTED_INTS=OFF"
  ++ lib.optional eri2PureSh "-DLIBINT2_ERI2_PURE_SH=ON"
  ++ lib.optional eri3PureSh "-DLIBINT2_ERI3_PURE_SH=ON"
  ++ lib.optional enableFortran "-DLIBINT2_ENABLE_FORTRAN=ON"
  ++ lib.optional enableSSE "-DLIBINT2_REALTYPE=libint2::simd::VectorSSEDouble";

  meta = {
    description = "Library for the evaluation of molecular integrals of many-body operators over Gaussian functions";
    homepage = "https://github.com/evaleev/libint";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      markuskowa
      sheepforce
    ];
    platforms = [ "x86_64-linux" ];
  };
})
