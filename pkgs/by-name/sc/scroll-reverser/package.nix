{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "scroll-reverser";
  version = "1.9";

  src = fetchurl {
    url = "https://pilotmoon.com/downloads/ScrollReverser-${finalAttrs.version}.zip";
    hash = "sha256-CWHbtvjvTl7dQyvw3W583UIZ2LrIs7qj9XavmkK79YU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    unzip -d "$out/Applications" $src

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
