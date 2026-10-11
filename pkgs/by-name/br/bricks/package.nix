{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
  qemu,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bricks";
  version = "0-unstable-2020-03-10";

  src = fetchFromGitHub {
    owner = "nanochess";
    repo = "bricks";
    rev = "8fb4d78f50e43c19a9ba35d68692cb2abe04e1df";
    hash = "sha256-f7X4G1hNdaeBSDnIusLSAE+VoqVlLFq0ebi8Y5STtFo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    nasm
    makeWrapper
  ];

  buildInputs = [ qemu ];

  installPhase = ''
    runHook preInstall

    install -Dm644 bricks.img \
      $out/share/bricks/bricks.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/bricks \
      --add-flags "-drive format=raw,file=$out/share/bricks/bricks.img,if=floppy,readonly=on"
    runHook postInstall
  '';

  meta = {
    description = "510-byte boot sector brick breaker game";
    homepage = "https://github.com/nanochess/bricks";
    mainProgram = "bricks";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
