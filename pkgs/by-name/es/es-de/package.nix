{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "es-de";
  version = "3.4.1";

  src = fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/288156961/download";
    hash = "sha256-PGGkTXONVRY9qljt5wcgtCWg32JGDATcI908pYZyNYE=";
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
