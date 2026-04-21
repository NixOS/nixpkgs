{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-usage-tracker";
  version = "3.1.1";

  src = fetchzip {
    url = "https://github.com/hamed-elfayome/Claude-Usage-Tracker/releases/download/v${finalAttrs.version}/Claude-Usage.zip";
    hash = "";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Claude Usage.app" $out/Applications/

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native macOS menu bar app for tracking Claude AI usage limits in real-time. Built with Swift/SwiftUI.";
    homepage = "https://github.com/hamed-elfayome/Claude-Usage-Tracker";
    changelog = "https://github.com/hamed-elfayome/Claude-Usage-Tracker/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ myzel394 ];
  };
})
