{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
let
  pname = "auto-claude";
  version = "2.7.4";

  src = fetchurl {
    url = "https://github.com/AndyMik90/Auto-Claude/releases/download/v${version}/Auto-Claude-${version}-linux-x86_64.AppImage";
    hash = "sha256-8aq8WEv64ZpeEVkEU3+L6n2doP8AFeKM8BcnA+thups=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      libsecret
      libGL
      mesa
    ];

  extraInstallCommands = ''
    # Install desktop file
    install -Dm644 ${appimageContents}/auto-claude-ui.desktop \
      $out/share/applications/${pname}.desktop

    # Install icon (only 4096x4096 available in AppImage)
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/4096x4096/apps/auto-claude-ui.png \
      $out/share/icons/hicolor/4096x4096/apps/${pname}.png

    # Fix desktop file paths
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U' \
      --replace-fail 'Icon=auto-claude-ui' 'Icon=${pname}'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Autonomous multi-agent coding framework powered by Claude AI";
    homepage = "https://github.com/AndyMik90/Auto-Claude";
    downloadPage = "https://github.com/AndyMik90/Auto-Claude/releases";
    changelog = "https://github.com/AndyMik90/Auto-Claude/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gui-wf ];
    mainProgram = "auto-claude";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
