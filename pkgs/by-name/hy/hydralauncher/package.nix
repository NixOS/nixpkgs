{
  lib,
  fetchurl,
  appimageTools,
  nix-update-script,
}:
let
  pname = "hydralauncher";
  version = "3.7.4";
  src = fetchurl {
    url = "https://github.com/hydralauncher/hydra/releases/download/v${version}/hydralauncher-${version}.AppImage";
    hash = "sha256-A68WatvQrq7QI7DvzFNkG5Sgsz6fZkaxc1soeAaDwOs=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname src version; };
in
appimageTools.wrapType2 {
  inherit pname src version;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/hydralauncher.png \
      $out/share/icons/hicolor/512x512/apps/hydralauncher.png

    install -Dm644 ${appimageContents}/hydralauncher.desktop \
      $out/share/applications/hydralauncher.desktop
    substituteInPlace $out/share/applications/hydralauncher.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${placeholder "out"}/bin/hydralauncher'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Game launcher with its own embedded bittorrent client";
    homepage = "https://github.com/hydralauncher/hydra";
    changelog = "https://github.com/hydralauncher/hydra/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "hydralauncher";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
