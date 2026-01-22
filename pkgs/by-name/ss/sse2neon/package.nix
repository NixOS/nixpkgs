{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sse2neon";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "DLTcollab";
    repo = "sse2neon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vb9k+KjiGodVngza0R18LjfPTlsqFbzqXZqefm6KHj0=";
  };

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
