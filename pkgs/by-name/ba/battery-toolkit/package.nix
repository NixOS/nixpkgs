{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "battery-toolkit";
  version = "1.8";

  src = fetchzip {
    url = "https://github.com/mhaeuser/Battery-Toolkit/releases/download/${finalAttrs.version}/Battery-Toolkit-${finalAttrs.version}.zip";
    hash = "sha256-gsEXTE+pM+rsBhTeup7cWcUljY8u0T+ETON7JeA6g1A=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Battery Toolkit.app" "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Control the platform power state of your Apple Silicon Mac";
    longDescription = ''
      Battery Toolkit allows you to control battery charging behavior on Apple Silicon Macs.
      Features include setting upper and lower charge limits, disabling the power adapter,
      and manual control over charging state.
    '';
    homepage = "https://github.com/mhaeuser/Battery-Toolkit";
    changelog = "https://github.com/mhaeuser/Battery-Toolkit/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shgew ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
