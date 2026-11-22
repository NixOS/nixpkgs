{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "es-de";
  version = "3.5.0";

  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/18817634/packages/generic/ES-DE_Stable/${finalAttrs.version}/ES-DE_x64.AppImage";
    hash = "sha256-q8KZmhI4X4V3W9P5hvqJHHa2nfN5H3wS5MeDzzw2MPU=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract {
        inherit (finalAttrs) pname version src;
      };
    in
    ''
      install -Dm 444 ${appimageContents}/org.es_de.frontend.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url"
      "https://gitlab.com/api/v4/projects/18817634/repository/archive.tar.gz?sha=HEAD"
    ];
  };

  meta = {
    description = "Frontend for browsing and launching games from your multi-platform collection.";
    homepage = "https://es-de.org/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ poacher ];
    mainProgram = "es-de";
  };
})
