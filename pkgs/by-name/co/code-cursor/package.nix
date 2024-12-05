{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
  writeScript,
}:
let
  pname = "cursor";
  version = "0.43.0";
  appKey = "230313mzl4w4u92";
  src = fetchurl {
    url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.43.0-build-24112423a8e6ct7-x86_64.AppImage";
    hash = "sha256-IcAUXGSMHxGd5Ak4cYA9/2YYg8UA+cRBGgnOupDuRXs=";
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update"

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl yq coreutils gnused common-updater-scripts
    set -eu -o pipefail
    latestLinux="$(curl -s https://download.todesktop.com/${appKey}/latest-linux.yml)"
    version="$(echo "$latestLinux" | yq -r .version)"
    filename="$(echo "$latestLinux" | yq -r '.files[] | .url | select(. | endswith(".AppImage"))')"
    url="https://download.todesktop.com/${appKey}/$filename"
    currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

    if [[ "$version" != "$currentVersion" ]]; then
      hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url")")
      update-source-version code-cursor "$version" "$hash" "$url" --source-key=src.src
    fi
  '';

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
