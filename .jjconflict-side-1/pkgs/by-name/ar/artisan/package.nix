{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
let
  pname = "artisan";
  version = "3.1.4";

  src = fetchurl {
    url = "https://github.com/artisan-roaster-scope/artisan/releases/download/v${version}/${pname}-linux-${version}.AppImage";
    hash = "sha256-GU9DCAIMioPRUC1IDu8SbhD802pWEH7MlALnQH+Y4oU=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/org.artisan_scope.artisan.desktop $out/share/applications/org.artisan_scope.artisan.desktop
    install -m 444 -D ${appimageContents}/artisan.png $out/share/applications/artisan.png
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v([\\d.]+)" ];
  };

  meta = {
    description = "visual scope for coffee roasters";
    homepage = "https://artisan-scope.org/";
    changelog = "https://github.com/artisan-roaster-scope/artisan/releases/tag/v${version}";
    downloadPage = "https://github.com/artisan-roaster-scope/artisan/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "artisan";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ bohreromir ];
    platforms = [ "x86_64-linux" ];
  };
}
