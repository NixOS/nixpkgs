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
  version = "3.01";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${finalAttrs.version}/nasm-${finalAttrs.version}.tar.xz";
    hash = "sha256-tzJMvobnZ7ZfJvRn7YsSrYDhJOPMuJB2hVyY5Dqe3dQ=";
  };

  patches = [
    # Backport patches fixing nasm with gcc 15 and musl (and other?) platforms
    # https://github.com/netwide-assembler/nasm/issues/169
    (fetchpatch {
      url = "https://github.com/netwide-assembler/nasm/commit/44e89ba9b650b5e1533bca43682e167f51a3511f.patch";
      hash = "sha256-zVeMFhoSY/HGYr4meIWBgt5Unq1fA8lM6h1Cl5fpbxo=";
    })
    (fetchpatch {
      url = "https://github.com/netwide-assembler/nasm/commit/746e7c9efa37cec9a44d84a1e96b8c38f385cc1f.patch";
      hash = "sha256-aXVS70O/wUkW8xtkwF7uwrQfTgGcNvxHrtGC0sjIPto=";
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
