{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
  writeScript,
  undmg,
}:

let
  pname = "cursor";
  version = "0.44.11";
  appKey = "230313mzl4w4u92";

  # tip: download and use nix hash file <filename> to get the hash, since mac dmg urls contain spaces / %20s
  sources = {
    x86_64-linux = {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-x86_64.AppImage";
      hash = "sha256-eOZuofnpED9F6wic0S9m933Tb7Gq7cb/v0kRDltvFVg=";
    };
    aarch64-linux = {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-arm64.AppImage";
      hash = "sha256-mxq7tQJfDccE0QsZDZbaFUKO0Xc141N00ntX3oEYRcc=";
    };
    x86_64-darwin = {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.44.11%20-%20Build%20250103fqxdt5u9z-x64.dmg";
      hash = "sha256-JKPClcUD2W3KWRlRTomDF4FOOA1DDw3iAQ+IH7yan+E=";
    };
    aarch64-darwin = {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.44.11%20-%20Build%20250103fqxdt5u9z-arm64.dmg";
      hash = "sha256-0HDnRYfy+jKJy5dvaulQczAoFqYmGGWcdhIkaFZqEPA=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenvNoCC.hostPlatform.system}) url hash;
  };

  installPhase =
    if stdenvNoCC.isDarwin then
      ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -r *.app $out/Applications/
        runHook postInstall
      ''
    else
      ''
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

  appimageContents = appimageTools.extractType2 { inherit version pname src; };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenvNoCC.isDarwin [ undmg ];

  sourceRoot = ".";

  inherit installPhase;

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl yq coreutils gnused common-updater-scripts
    set -eu -o pipefail

    # Check both Linux and Mac versions to ensure they match
    latestLinux="$(curl -s https://download.todesktop.com/${appKey}/latest-linux.yml)"
    latestMac="$(curl -s https://download.todesktop.com/${appKey}/latest-mac.yml)"

    linuxVersion="$(echo "$latestLinux" | yq -r .version)"
    macVersion="$(echo "$latestMac" | yq -r .version)"

    if [ "$linuxVersion" != "$macVersion" ]; then
      echo "Warning: Linux version ($linuxVersion) and Mac version ($macVersion) differ"
      exit 1
    fi

    version="$linuxVersion"
    currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

    if [[ "$version" != "$currentVersion" ]]; then
      echo "Updating code-cursor from $currentVersion to $version"
      update-source-version code-cursor "$version"
    else
      echo "code-cursor is already up to date at version $version"
    fi
  '';

  meta = {
    description = "AI-powered code editor built on vscode";
    homepage = "https://cursor.com";
    changelog = "https://cursor.com/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      sarahec
      aspauldingcode
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };
}
