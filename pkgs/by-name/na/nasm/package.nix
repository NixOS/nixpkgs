{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  perl,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nasm";
  version = "3.02";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${finalAttrs.version}/nasm-${finalAttrs.version}.tar.xz";
    hash = "sha256-hzNuulO0rP6RdCSrXVANKwBU2fUUjTXCJzzPLPtxLw0=";
  };

  patches = [
    # Backport the fix for https://github.com/netwide-assembler/nasm/issues/203
    # buffer overflow.
    (fetchpatch {
      name = "output-oob-fix.patch";
      url = "https://github.com/netwide-assembler/nasm/commit/8890d723d0aa9ed1a790e2ce1c55eee8dfa0cf94.patch";
      hash = "sha256-m03+bhKTgKlqeRLGZIy6GO5BTPIJ3r398VQrtN4waaw=";
    })
  ];

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make golden
    make test

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/netwide-assembler/nasm.git";
    rev-prefix = "nasm-";
    ignoredVersions = "rc.*";
  };

  meta = {
    homepage = "https://www.nasm.us/";
    description = "80x86 and x86-64 assembler designed for portability and modularity";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pSub
    ];
    mainProgram = "nasm";
    license = lib.licenses.bsd2;
  };
})
