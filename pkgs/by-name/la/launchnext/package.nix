{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "launchnext";
  version = "2.3.0";

  src = fetchzip {
    url = "https://github.com/RoversX/LaunchNext/releases/download/${finalAttrs.version}/LaunchNext${finalAttrs.version}.zip";
    hash = "sha256-gdfSkBWLXd1N17ruVlRs77q3VMX2nfmAYitPOVnDe3k=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R LaunchNext.app $out/Applications/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bring Launchpad back in MacOS26+, highly customizable, powerful, free";
    homepage = "https://closex.org/launchnext/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
