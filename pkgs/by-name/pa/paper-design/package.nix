{
  appimageTools,
  asar,
  common-updater-scripts,
  curl,
  fetchurl,
  gnugrep,
  gnused,
  lib,
  writeShellApplication,
}:

let
  pname = "paper-design";
  version = "0.5.5";

  # Upstream always serves the latest build from this fixed URL, but the
  # version is still exposed in the Content-Disposition filename, so
  # passthru.updateScript below can discover and bump it automatically.
  src = fetchurl {
    url = "https://download.paper.design/linux/appImage";
    hash = "sha256-g+pXlFzDKr8G2bX7UzlrZINn8Ctd64KAKUYKuiOW1Lo=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;

    # Get rid of the autoupdater
    postExtract = ''
      ${lib.getExe asar} extract $out/resources/app.asar app
      sed -i 's/async isUpdateAvailable.*/async isUpdateAvailable(updateInfo) { return false;/g' app/node_modules/electron-updater/out/AppUpdater.js
      ${lib.getExe asar} pack app $out/resources/app.asar
    '';
  };
in
(appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/paper-desktop.desktop $out/share/applications/paper-design.desktop
    install -Dm444 ${appimageContents}/paper-desktop.png $out/share/icons/hicolor/1024x1024/apps/paper-design.png
    substituteInPlace $out/share/applications/paper-design.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=paper-design %U' \
      --replace-fail 'Icon=paper-desktop' 'Icon=paper-design'
  '';

  passthru.updateScript = writeShellApplication {
    name = "update-paper-design";
    runtimeInputs = [
      common-updater-scripts
      curl
      gnugrep
      gnused
    ];
    text = ''
      version="$(curl -sI https://download.paper.design/linux/appImage \
        | grep -o 'filename="[^"]*"' \
        | sed -E 's/.*paper-desktop-([0-9.]+)x86_64\.AppImage.*/\1/')"
      update-source-version paper-design "$version"
    '';
  };

  meta = {
    description = "Native desktop client for a browser-based collaborative design tool";
    homepage = "https://paper.design";
    changelog = "https://paper.design/build-log";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ crisautomata ];
    mainProgram = "paper-design";
    platforms = [ "x86_64-linux" ];
  };
}).overrideAttrs {
  # wrapType2 extracts `src` itself for the runtime contents, ignoring
  # appimageContents above, so the autoupdater patch never took effect
  # without this override.
  contents = appimageContents;
}
