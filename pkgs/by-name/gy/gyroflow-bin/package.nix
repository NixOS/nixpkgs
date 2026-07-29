{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  makeWrapper,
  gyroflow,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gyroflow-bin";
  version = "1.6.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/gyroflow/gyroflow/releases/download/v${finalAttrs.version}/Gyroflow-mac-universal.dmg";
    hash = "sha256-++Jnk8Y58UENiZXeutGIchWHEIy2p0Ik6Hn3nku4ocA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Gyroflow v${finalAttrs.version}/Gyroflow.app" $out/Applications/

    makeWrapper $out/Applications/Gyroflow.app/Contents/MacOS/gyroflow $out/bin/gyroflow

    runHook postInstall
  '';

  meta = gyroflow.meta // {
    description = "Advanced gyro-based video stabilization tool (pre-built macOS binary)";
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "gyroflow";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  passthru.updateScript = nix-update-script { };
})
