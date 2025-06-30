{
  lib,
  stdenv,
  fetchFromGitHub,
  safestringlib,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bwa-mem2";
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "bwa-mem2";
    repo = "bwa-mem2";
    rev = "cf4306a47dac35e7e79a9e75398a35f33900cfd0";
    hash = "sha256-hY8nLRFWt0GAElhDIcYdUX6cJrzOE3NlYRQr0tC3on4=";
  };

  buildInputs = [ zlib ];

  buildFlags = [
    (
      if stdenv.hostPlatform.sse4_2Support then
        "arch=sse42"
      else if stdenv.hostPlatform.avxSupport then
        "arch=avx"
      else if stdenv.hostPlatform.avx2Support then
        "arch=avx2"
      else if stdenv.hostPlatform.avx512Support then
        "arch=avx512"
      else
        "arch=sse41"
    )
  ];

  patches = [
    ./no-submodule.patch
  ];

  # Also, patch the tests
  postPatch =
    # Force path to static link, otherwise, it fails at runtime to
    # find the shared library
    ''
      substituteInPlace Makefile \
        --replace-fail "-Iext/safestringlib/include" "-I${safestringlib}/include" \
        --replace-fail "-Lext/safestringlib" "-L${safestringlib}/lib"
    ''
    # Make test compile by changing the compiler and path to library
    # Remove xeonbsw test that fails to compile due to missing _rdsc
    # also, not portable
    + ''
      substituteInPlace test/Makefile \
        --replace-fail "icpc" "g++" \
        --replace-fail "../ext/safestringlib/libsafestring.a"  \
                       "${safestringlib}/lib/libsafestring.a" \
        --replace-fail \
          "fmi_test smem2_test bwt_seed_strategy_test sa2ref_test xeonbsw" \
          "fmi_test smem2_test bwt_seed_strategy_test sa2ref_test"
    '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=register"
      "-Wno-error=implicit-function-declaration"
    ]
  );

  nativeBuildInputs = [
    safestringlib
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bwa-mem2* $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Next version of the bwa-mem algorithm in bwa, a software package for mapping low-divergent sequences against a large reference genome";
    mainProgram = "bwa-mem2";
    license = licenses.mit;
    homepage = "https://github.com/bwa-mem2/bwa-mem2/";
    changelog = "https://github.com/bwa-mem2/bwa-mem2/blob/${finalAttrs.src.rev}/NEWS.md";
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ apraga ];
  };
})
