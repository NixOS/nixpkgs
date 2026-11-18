{
  stdenv,
  fetchFromGitHub,
  lib,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m1ddc";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "waydabber";
    repo = "m1ddc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nBCtPHGM1nCQQkMqLg/zJZ4BaOxSsipxm8kCiElceSI=";
  };

  postPatch = ''
    substituteInPlace sources/ioregistry.m \
        --replace-fail kIOMainPortDefault kIOMasterPortDefault
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp m1ddc $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Control external displays using DDC/CI on Apple Silicon Macs";
    homepage = "https://github.com/waydabber/m1ddc";
    license = lib.licenses.mit;
    mainProgram = "m1ddc";
    maintainers = [ lib.maintainers.amarshall ];
    platforms = [ "aarch64-darwin" ];
  };
})
