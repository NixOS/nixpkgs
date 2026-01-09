{
  bzip2,
  fetchFromGitHub,
  lib,
  openssl,
  stdenv,
  unstableGitUpdater,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dmg2img";
  version = "1.6.7-unstable-2020-12-27";

  src = fetchFromGitHub {
    owner = "Lekensteyn";
    repo = "dmg2img";
    rev = "a3e413489ccdd05431401357bf21690536425012";
    hash = "sha256-DewU5jz2lRjIRiT0ebjPRArsoye33xlEGfhzd4xnT4A=";
  };

  buildInputs = [
    bzip2
    openssl
    zlib
  ];

  preBuild = ''
    sed -i "s/1.6.5/${finalAttrs.version}/" dmg2img.c
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dmg2img vfdecrypt -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Tool which allows converting Apple compressed dmg archives to standard (hfsplus) image disk files";
    homepage = "https://github.com/Lekensteyn/dmg2img";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "dmg2img";
  };
})
