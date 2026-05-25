{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "handheld-daemon-ui";
  version = "3.4.0";

  src = fetchurl {
    url = "https://github.com/hhd-dev/hhd-ui/releases/download/v${version}/hhd-ui.Appimage";
    hash = "sha256-OeZMh3lC3fluwz1pU3JnLRkwFYiIkthGuclYkOJm430=";
  };
  extractedFiles = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Handheld-daemon expects the UI binary to be called hhd-ui
    mv $out/bin/${pname}* $out/bin/hhd-ui

    mkdir -p $out/share/applications
    substitute ${extractedFiles}/hhd-ui.desktop \
      $out/share/applications/hhd-ui.desktop \
      --replace-fail "Exec=AppRun" "Exec=hhd-ui" \
      --replace-fail "Categories=game;" "Categories=Game;"
    iconDir=$out/share/icons/hicolor/512x512/apps
    mkdir -p $iconDir
    cp ${extractedFiles}/hhd-ui.png $iconDir
  '';

  meta = {
    description = "UI for the Handheld Daemon";
    homepage = "https://github.com/hhd-dev/hhd-ui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ toast ];
    mainProgram = "hhd-ui";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
