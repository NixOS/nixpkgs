{
  lib,
  stdenv,
  nasm,
  fetchFromGitLab,
  makeWrapper,
  qemu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asmsnake";
  version = "0-unstable-2017-02-03";

  src = fetchFromGitLab {
    owner = "pmikkelsen";
    repo = "asm_snake";
    rev = "981e91a050e253e55770c8534f7f0a657941ca89";
    hash = "sha256-ScaYeog6mm6tRWOZCN0A3/DYlB5lhYLwmJx0mWxT5uo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    nasm
  ];

  buildInputs = [ qemu ];

  installPhase = ''
    runHook preInstall

    install -Dm644 snake.bin \
      $out/share/asmsnake/snake.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/asmsnake \
      --add-flags "-drive format=raw,file=$out/share/asmsnake/snake.img,if=floppy,readonly=on"

    runHook postInstall
  '';

  meta = {
    description = "Snake game in x86 assembly";
    homepage = "https://gitlab.com/pmikkelsen/asm_snake";
    mainProgram = "asmsnake";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
