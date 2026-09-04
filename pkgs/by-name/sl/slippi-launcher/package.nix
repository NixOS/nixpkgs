{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
}:
let
  pname = "slippi-launcher";
  version = "2.13.3";

  src =
    fetchurl
      {
        x86_64-linux = {
          url = "https://github.com/project-slippi/slippi-launcher/releases/download/v${version}/Slippi-Launcher-${version}-x86_64.AppImage";
          hash = "sha256-5tFl0ezk/yMkfd59kUKxGZBvt5MqnoCvxRSepy7O8BQ=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    homepage = "https://slippi.gg/";
    description = "The way to play Slippi Online and watch replays.";
    mainProgram = "slippi-launcher";
    changelog = "https://github.com/project-slippi/slippi-launcher/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      chuu-p
    ];
  };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract {
        inherit pname version src;
      };
    in
    ''
      # Install desktop entry
      install -Dm444 \
        ${appimageContents}/slippi-launcher.desktop \
        $out/share/applications/slippi-launcher.desktop

      # Install icon
      install -Dm444 \
        ${appimageContents}/slippi-launcher.png \
        $out/share/pixmaps/slippi-launcher.png

      # Fix Exec line in desktop file to point to wrapped binary
      substituteInPlace $out/share/applications/slippi-launcher.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=slippi-launcher'

      # Some Electron desktop files include extra args – be defensive
      substituteInPlace $out/share/applications/slippi-launcher.desktop \
        --replace 'Exec=AppRun %U' 'Exec=slippi-launcher %U'
    '';
}
