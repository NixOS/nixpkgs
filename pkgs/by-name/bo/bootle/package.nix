{
  lib,
  stdenv,
  nasm,
  fetchFromGitHub,
  makeWrapper,
  qemu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootle";
  version = "0-unstable-2022-02-28";

  src = fetchFromGitHub {
    owner = "nanochess";
    repo = "bootle";
    rev = "6ea8d9aaf7d4ad9302dcfabc452a595bfe19fddc";
    hash = "sha256-bGEPViBEUFr41MY3DGlJmbOqeFlSHQd1R+CMl7Dp4A0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    nasm
  ];

  buildInputs = [ qemu ];

  buildPhase = ''
    runHook preBuild

    make

    nasm -f bin \
      -o bootle2.img \
      bootle2.asm
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 bootle.img \
      $out/share/bootle/bootle.img

    install -Dm644 bootle2.img \
      $out/share/bootle/bootle2.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/bootle \
      --add-flags "-drive format=raw,file=$out/share/bootle/bootle.img,if=floppy,readonly=on"



    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/bootle2 \
      --add-flags "-drive format=raw,file=$out/share/bootle/bootle2.img,if=floppy,readonly=on"

    runHook postInstall
  '';

  meta = {
    description = "A Wordle clone in a x86 assembly";
    homepage = "https://github.com/nanochess/bootle";
    mainProgram = "bootle";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
