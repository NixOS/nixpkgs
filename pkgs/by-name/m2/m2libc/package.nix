{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m2libc";
  version = "unstable-2023-05-22";

  src = fetchFromGitHub {
    owner = "oriansj";
    repo = "M2libc";
    rev = "de7c75f144176c3b9be77695d9bf94440445aeae";
    hash = "sha256-248plvODhBRfmx7zOmf05ICbk8vzSbaceZJ0j+wPaAY=";
  };

  patches = [
    # # aarch64: syscall: mkdir -> mkdirat
    # https://github.com/oriansj/M2libc/pull/17
    (fetchpatch {
      url = "https://github.com/oriansj/M2libc/commit/ff7c3023b3ab6cfcffc5364620b25f8d0279e96b.patch";
      hash = "sha256-QAKddv4TixIQHpFa9SVu9fAkeKbzhQaxjaWzW2yJy7A=";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r . $out/include/M2libc

    runHook postInstall
  '';

  meta = with lib; {
    description = "More standards compliant C library written in M2-Planet's C subset";
    homepage = "https://github.com/oriansj/m2libc";
    license = licenses.gpl3Only;
    teams = [ teams.minimal-bootstrap ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
      "riscv32-linux"
      "riscv64-linux"
    ];
  };
})
