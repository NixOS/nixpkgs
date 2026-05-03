{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flint,
  gmp,
  mpfr,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msolve";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "algebraic-solving";
    repo = "msolve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zty220Elqa8SACM9OlemVNEMbMx9DkhjJjUekZFR67A=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    flint
    gmp
    mpfr
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  configureFlags =
    let
      mkCpuFeatureFlag = acvar: cond: "ax_cv_have_${acvar}_cpu_ext=${lib.boolToYesNo cond}";
    in
    [
      (mkCpuFeatureFlag "sse3" stdenv.hostPlatform.sse3Support)
      (mkCpuFeatureFlag "ssse3" stdenv.hostPlatform.ssse3Support)
      (mkCpuFeatureFlag "sse41" stdenv.hostPlatform.sse4_1Support)
      (mkCpuFeatureFlag "sse42" stdenv.hostPlatform.sse4_2Support)
      (mkCpuFeatureFlag "sse4a" stdenv.hostPlatform.sse4_aSupport)
      (mkCpuFeatureFlag "avx" stdenv.hostPlatform.avxSupport)
      (mkCpuFeatureFlag "avx2" stdenv.hostPlatform.avx2Support)
    ]
    ++ map (lib.flip mkCpuFeatureFlag stdenv.hostPlatform.avx512Support) [
      "avx512f"
      "avx512cd"
      "avx512pf"
      "avx512er"
      "avx512vl"
      "avx512bw"
      "avx512dq"
      "avx512ifma"
      "avx512vbmi"
    ]
    ++ [
      (mkCpuFeatureFlag "fma3" stdenv.hostPlatform.fmaSupport)
      (mkCpuFeatureFlag "fma4" stdenv.hostPlatform.fma4Support)
    ];

  doCheck = true;

  meta = {
    description = "Library for polynomial system solving through algebraic methods";
    mainProgram = "msolve";
    homepage = "https://msolve.lip6.fr";
    changelog = "https://github.com/algebraic-solving/msolve/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.patterns.is32bit ];
  };
})
