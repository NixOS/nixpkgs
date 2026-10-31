{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
  qemu,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lights";
  version = "0-unstable-2020-03-10";

  src = fetchFromGitHub {
    owner = "nanochess";
    repo = "lights";
    rev = "4f92b327c1531f997fc41ca949bc6e3905b08dfd";
    hash = "sha256-/KwrTsvf8dssh2isqMCu7KJG+STUxR3+ErumxWTOJL4=";
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

    install -Dm644 lights.img \
      $out/share/lights/lights.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/lights \
      --add-flags "-drive format=raw,file=$out/share/lights/lights.img,if=floppy,readonly=on"
    runHook postInstall
  '';

  meta = {
    description = "510-byte boot sector sequence memory game";
    homepage = "https://github.com/nanochess/lights";
    mainProgram = "lights";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];

  };
})
