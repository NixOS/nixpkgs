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
  version = "0.45.14";
  src = fetchurl {
    url = "https://archive.org/download/cursor-0.45.14x86_64/cursor-0.45.14x86_64.AppImage";
    hash = "sha256-5MGWJi8TP+13jZf6YMMUU5uYY/3OBTFxtGpirvgj8ZI=";
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

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl nix-prefetch-url
    set -eu -o pipefail
    url="https://archive.org/download/cursor-0.45.14x86_64/cursor-${version}x86_64.AppImage"
    currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

    echo "Current version: $currentVersion, specified version: ${version}"
    echo "Please manually update the version and hash in the Nix expression if needed."
    hash=$(nix-prefetch-url "$url")
    echo "New hash: $hash"
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
