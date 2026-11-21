{
  lib,
  stdenv,
  nasm,
  fetchFromGitHub,
  makeWrapper,
  qemu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cubicdoom";
  version = "0-unstable-2020-03-10";

  src = fetchFromGitHub {
    owner = "nanochess";
    repo = "cubicDoom";
    rev = "5e88760a968c6f9a9088e515613b24abc0131d46";
    hash = "sha256-EnkkURcjRTr3mq6EXTr62iMDrat5cl8jqolPb3cAYik=";
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

    install -Dm644 doom.img \
      $out/share/cubicdoom/doom.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/cubicdoom \
      --add-flags "-drive format=raw,file=$out/share/cubicdoom/doom.img,if=floppy,readonly=on"

    runHook postInstall
  '';

  meta = {
    description = "512-byte boot sector raycasting game";
    homepage = "https://github.com/nanochess/cubicDoom";
    mainProgram = "cubicdoom";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
