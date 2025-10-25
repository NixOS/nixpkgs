{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "roblox-studio";
  version = "0.681.0.6810806";

  src = fetchzip {
    url = "https://setup.rbxcdn.com/mac${
      if (stdenvNoCC.hostPlatform.isAarch64) then "/arm64" else ""
    }/version-cbe19a016a4e4b69-RobloxStudioApp.zip";
    hash =
      if (stdenvNoCC.hostPlatform.isAarch64) then
        "sha256-P66gu3cBf634N8TycQ26D1XRngJOsO1FdWR97+QzNhc="
      else
        "sha256-KtErAXWoFXiFdIiIe3mnxMj3fNPUPLGo+F8phlk4l20=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R RobloxStudio.app/ "$out/Applications/Roblox Studio.app"

    runHook postInstall
  '';

  meta = {
    description = "Game engine of the Roblox platform";
    homepage = "https://create.roblox.com/docs/studio";
    downloadPage = "https://www.roblox.com/download/studio";
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ valentinegb ];
    platforms = lib.platforms.darwin;
  };
}
