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
  version = "0.44.11";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-x86_64.AppImage";
      hash = "sha256-eOZuofnpED9F6wic0S9m933Tb7Gq7cb/v0kRDltvFVg=";
    };
    aarch64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-arm64.AppImage";
      hash = "sha256-mxq7tQJfDccE0QsZDZbaFUKO0Xc141N00ntX3oEYRcc=";
    };
  };

  supportedPlatforms = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  src = sources.${stdenvNoCC.hostPlatform.system};

  appimageContents = appimageTools.extractType2 {
    inherit version pname src;
  };

  wrappedAppImage = appimageTools.wrapType2 { inherit version pname src; };

  appimageInstall = ''
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

in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = wrappedAppImage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = appimageInstall;

  passthru = {
    inherit sources;
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl yq coreutils gnused common-updater-scripts
      set -eu -o pipefail
      baseUrl="https://download.todesktop.com/230313mzl4w4u92"
      latestLinux="$(curl -s $baseUrl/latest-linux.yml)"
      version="$(echo "$latestLinux" | yq -r .version)"
      filename="$(echo "$latestLinux" | yq -r '.files[] | .url | select(. | endswith(".AppImage"))')"
      linuxStem="$(echo "$filename" | sed -E s/^\(cursor-.+-build-.*\)-.+$/\\1/)"

      currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

      if [[ "$version" != "$currentVersion" ]]; then
        for platform in ${lib.escapeShellArgs supportedPlatforms}; do
          if [ $platform = "x86_64-linux" ]; then
            url="$baseUrl/$linuxStem-x86_64.AppImage"
          elif [ $platform = "aarch64-linux" ]; then
            url="$baseUrl/$linuxStem-arm64.AppImage"
          else
            echo "Unsupported platform: $platform"
            exit 1
          fi

          hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url")")
          update-source-version code-cursor $version $hash $url --system=$platform --ignore-same-version --source-key="sources.$platform"
        done
      fi
    '';
  };

  meta = {
    description = "AI-powered code editor built on vscode";
    homepage = "https://cursor.com";
    changelog = "https://cursor.com/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ sarahec ];
    platforms = lib.platforms.linux;
    mainProgram = "cursor";
  };
}
