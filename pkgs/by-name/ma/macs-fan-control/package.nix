{
  fetchzip,
  lib,
  nix-update-script,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "macs-fan-control";
  version = "1.5.19";

  src = fetchzip {
    url = "https://github.com/crystalidea/macs-fan-control/releases/download/v${finalAttrs.version}/macsfancontrol.zip";
    hash = "sha256-2CODlhsSTAVg9S4byDRCztEDAHvsJ3asohNwgYLCNbc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Macs\ Fan\ Control.app
    cp -R . $out/Applications/Macs\ Fan\ Control.app

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Control fans on Apple computers";
    homepage = "https://crystalidea.com/macs-fan-control";
    changelog = "https://github.com/crystalidea/macs-fan-control/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ veyndan ];
    platforms = lib.platforms.darwin;
  };
})
