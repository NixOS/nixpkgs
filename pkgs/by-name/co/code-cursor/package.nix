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
  version = "0.47.9";

  inherit (stdenvNoCC) hostPlatform;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/b6fb41b5f36bda05cab7109606e7404a65d1ff32/linux/x64/Cursor-0.47.9-x86_64.AppImage";
      hash = "sha256-L0ZODGHmO8SDhqrnkq7jwi30c6l+/ESj+FXHVKghsfc=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/b6fb41b5f36bda05cab7109606e7404a65d1ff32/linux/arm64/Cursor-0.47.9-aarch64.AppImage";
      hash = "sha256-OhaKujLXt06DL43fY5vRaGZe3p8Y1mt22y5OrzM3mMk=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/82ef0f61c01d079d1b7e5ab04d88499d5af500e3/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-T5N8b/6HexQ2ZchWUb9CL3t9ks93O9WJgrDtxfE1SgU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/82ef0f61c01d079d1b7e5ab04d88499d5af500e3/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-ycroylfEZY/KfRiXvfOuTdyyglbg/J7DU12u6Xrsk0s=";
    };
  };

  source = sources.${hostPlatform.system};

  # Linux -- build from AppImage
  appimageContents = appimageTools.extractType2 {
    inherit version pname;
    src = source;
  };

  wrappedAppimage = appimageTools.wrapType2 {
    inherit version pname;
    src = source;
  };

in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = if hostPlatform.isLinux then wrappedAppimage else source;

  nativeBuildInputs =
    lib.optionals hostPlatform.isLinux [ makeWrapper ]
    ++ lib.optionals hostPlatform.isDarwin [ undmg ];

  sourceRoot = lib.optionalString hostPlatform.isDarwin ".";

  # Don't break code signing
  dontUpdateAutotoolsGnuConfigScripts = hostPlatform.isDarwin;
  dontConfigure = hostPlatform.isDarwin;
  dontFixup = hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/

    ${lib.optionalString hostPlatform.isLinux ''
      cp -r bin $out/bin
      mkdir -p $out/share/cursor

      # Copy icon
      install -Dm 644 ${appimageContents}/co.anysphere.cursor.png -t $out/share/icons/hicolor/256x256/apps/

      # Copy desktop file
      install -Dm 644 ${appimageContents}/cursor.desktop -t $out/share/applications/

      wrapProgram $out/bin/cursor \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update"
    ''}

    ${lib.optionalString hostPlatform.isDarwin ''
      APP_DIR="$out/Applications"
      CURSOR_APP="$APP_DIR/Cursor.app"
      mkdir -p "$APP_DIR"
      cp -Rp Cursor.app "$APP_DIR"
      mkdir -p "$out/bin"
      cat << EOF > "$out/bin/cursor"
      #!${stdenvNoCC.shell}
      open -na "$CURSOR_APP" --args "\$@"
      EOF
      chmod +x "$out/bin/cursor"
    ''}

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl yq coreutils gnused trurl common-updater-scripts
      set -eu -o pipefail

      # Check the latest version from Cursor's website
      version=$(curl -s "https://download.cursor.sh/latest-versions.json" | jq -r '.latestVers.main.ver')
      buildId=$(curl -s "https://download.cursor.sh/latest-versions.json" | jq -r '.latestVers.main.buildId')
      baseUrl="https://downloads.cursor.com/production/$buildId"

      currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

      if [[ "$version" != "$currentVersion" ]]; then
          for platform in "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"; do
              if [ $platform = "x86_64-linux" ]; then
                  url="$baseUrl/linux/x64/Cursor-$version-x86_64.AppImage"
              elif [ $platform = "aarch64-linux" ]; then
                  url="$baseUrl/linux/arm64/Cursor-$version-arm64.AppImage"
              elif [ $platform = "x86_64-darwin" ]; then
                  url="$baseUrl/darwin/x64/Cursor-$version-x64.dmg"
              elif [ $platform = "aarch64-darwin" ]; then
                  url="$baseUrl/darwin/arm64/Cursor-$version-arm64.dmg"
              else
                  echo "Unsupported platform: $platform"
                  exit 1
              fi

              url=$(trurl --accept-space "$url")
              hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url" --name "cursor-$version")")
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
    maintainers = with lib.maintainers; [
      sarahec
      aspauldingcode
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };
}
