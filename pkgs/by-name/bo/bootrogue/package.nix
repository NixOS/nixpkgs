{
  lib,
  stdenv,
  nasm,
  fetchFromGitHub,
  makeWrapper,
  qemu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootrogue";
  version = "0-unstable-2020-03-10";

  src = fetchFromGitHub {
    owner = "nanochess";
    repo = "bootRogue";
    rev = "118e1cb7818fdd152b4f008548408ed0ed45e06f";
    hash = "sha256-Nydj9gCkv5Tu3GQ6RdwoIDKb8xZF3UPudkkItNY694A=";
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

    install -Dm644 rogue.img \
      $out/share/bootrogue/rogue.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/bootrogue \
      --add-flags "-drive format=raw,file=$out/share/bootrogue/rogue.img,if=floppy,readonly=on"

    runHook postInstall
  '';

  meta = {
    description = "510-byte boot sector roguelike game";
    homepage = "https://github.com/nanochess/bootRogue";
    mainProgram = "bootrogue";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
