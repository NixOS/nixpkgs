{
  appimageTools,
  asar,
  common-updater-scripts,
  curl,
  fetchurl,
  gnused,
  lib,
  writeShellApplication,
}:

let
  pname = "paper-design";
  version = "0.5.6";

  # The public download link always redirects to the newest build, so
  # pin ToDesktop's real per-build URL instead. Its build id isn't
  # derivable from the version, so updateScript replaces the whole URL.
  src = fetchurl {
    url = "https://download.todesktop.com/2601167vjw8xe/paper-desktop-0.5.6-build-2608278ikbsisiz-x86_64.AppImage";
    hash = "sha256-gI/SInIcIn9C1jhLGVoHBuWrOghqNnLOQwtLuJYLCco=";
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
      gnused
    ];
    text = ''
      feed="$(curl -sf https://download.todesktop.com/2601167vjw8xe/latest-linux.yml)"
      version="$(echo "$feed" | sed -n 's/^version: *//p')"
      path="$(echo "$feed" | sed -n 's/^path: *//p')"
      update-source-version paper-design "$version" "" \
        "https://download.todesktop.com/2601167vjw8xe/$path"
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
}).overrideAttrs
  {
    # wrapType2 extracts `src` itself for the runtime contents, ignoring
    # appimageContents above, so the autoupdater patch never took effect
    # without this override.
    contents = appimageContents;
  }
