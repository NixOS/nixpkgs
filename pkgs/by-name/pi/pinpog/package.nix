{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
  qemu,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinpog";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "pinpog";
    tag = finalAttrs.version;
    hash = "sha256-9zhnSCHlzIYQYxl3MgGvrJBCfWfYLxVwLKjdXzrifRc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  makeFlags = [ "pinpog" ];

  nativeBuildInputs = [
    nasm
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 pinpog \
      $out/share/pinpog/pinpog.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/pinpog \
      --add-flags "-drive format=raw,file=$out/share/pinpog/pinpog.img,if=floppy,readonly=on"
    runHook postInstall
  '';

  meta = {
    description = "512-byte boot sector Pong like game";
    homepage = "https://github.com/tsoding/pinpog";
    changelog = "https://github.com/tsoding/pinpog/releases/tag/${finalAttrs.version}";
    mainProgram = "pinpog";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
