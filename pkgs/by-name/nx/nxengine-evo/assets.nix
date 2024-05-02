{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nxengine-assets";
  version = "2.6.4";

  src = fetchzip {
    url = "https://github.com/nxengine/nxengine-evo/releases/download/v${finalAttrs.version}/NXEngine-v${finalAttrs.version}-Linux.tar.xz";
    hash = "sha256-vBbbX6yBZ5CwdkxzO9Z/DjY1IMnKGKYNx6jzAgYUjcM=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nxengine/
    cp -r data/ $out/share/nxengine/data

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/nxengine/nxengine-evo";
    description = "Assets for nxengine-evo";
    license = with lib.licenses; [
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
