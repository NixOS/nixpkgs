{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "scroll-reverser";
  version = "2.1.1";

  src = fetchurl {
    url = "https://pilotmoon.com/downloads/ScrollReverser-${finalAttrs.version}.zip";
    hash = "sha256-ZUoruzaPOc98qa3LTYPBLFcvLGSIbvUBKUmv2Bz2lpE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v([0-9]*.*)"
      "--url"
      "https://github.com/pilotmoon/Scroll-Reverser"
    ];
  };

  meta = {
    description = "Tool to reverse the direction of scrolling";
    homepage = "https://pilotmoon.com/scrollreverser/";
    changelog = "https://github.com/pilotmoon/Scroll-Reverser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      stackptr
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
