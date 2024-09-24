{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
  writeShellApplication,
  curl,
  yq,
  common-updater-scripts,
}:
let
  pname = "cursor";
  version = "0.41.1";
  appKey = "230313mzl4w4u92";
  src = fetchurl {
    url = "https://download.todesktop.com/${appKey}/cursor-0.41.1-build-2409189xe3envg5-x86_64.AppImage";
    hash = "sha256-9zqktOR5UOMLkKLD1uJ8eNSujWnnyKAN9H8ejrgcfVU=";
  };
  appimageContents = appimageTools.extractType2 { inherit version pname src; };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = appimageTools.wrapType2 { inherit version pname src; };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/cursor
    cp -a ${appimageContents}/locales $out/share/cursor
    cp -a ${appimageContents}/resources $out/share/cursor
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/cursor.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/cursor.desktop --replace-fail "AppRun" "cursor"

    wrapProgram $out/bin/cursor \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} --no-update"

    runHook postInstall
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-cursor";
      runtimeInputs = [
        curl
        yq
        common-updater-scripts
      ];
      text = ''
        set -o errexit
        latestLinux="$(curl -s https://download.todesktop.com/${appKey}/latest-linux.yml)"
        version="$(echo "$latestLinux" | yq -r .version)"
        filename="$(echo "$latestLinux" | yq -r '.files[] | .url | select(. | endswith(".AppImage"))')"
        update-source-version code-cursor "$version" "" "https://download.todesktop.com/${appKey}/$filename" --source-key=src.src
      '';
    });
  };

  meta = {
    description = "AI-powered code editor built on vscode";
    homepage = "https://cursor.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ sarahec ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cursor";
  };
}
