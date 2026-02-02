{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sse2neon";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "DLTcollab";
    repo = "sse2neon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eD2Z4ZCybbqURHArENyiYVOFXHUEvpP5T3li/Bp8a24=";
  };

  # For some reason our nixpkgs clang/gcc has problems with Flush-to-zero
  # and Denormals-are-zero tests.
  preCheck = ''
    substituteInPlace tests/ieee754.cpp --replace-fail 'RUN_TEST(ftz_output' '// RUN_TEST(ftz_output'
    substituteInPlace tests/ieee754.cpp --replace-fail 'RUN_TEST(daz_input' '// RUN_TEST(daz_input'
  ''
  # On Darwin it fails also for NaN to 64-bit conversion
  # it works on bare-metal apple without nixpkgs
  # FAILED: res == indefinite || res == 0 (line 1753)
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace tests/nan.cpp --replace-fail 'RUN_TEST(cvtss_si64' '// RUN_TEST(cvtss_si64'
  '';

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 sse2neon.h $out/include/sse2neon.h

    runHook postInstall
  '';

  meta = {
    description = "C/C++ header file that converts Intel SSE intrinsics to Arm/Aarch64 NEON intrinsics";
    homepage = "https://github.com/DLTcollab/sse2neon";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gador ];
  };
})
