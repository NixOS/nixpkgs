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

  inherit (stdenvNoCC) buildPlatform;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-x86_64.AppImage";
      hash = "sha256-eOZuofnpED9F6wic0S9m933Tb7Gq7cb/v0kRDltvFVg=";
    };
    aarch64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-arm64.AppImage";
      hash = "sha256-mxq7tQJfDccE0QsZDZbaFUKO0Xc141N00ntX3oEYRcc=";
    };
    x86_64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.44.11%20-%20Build%20250103fqxdt5u9z-x64.dmg";
      hash = "sha256-JKPClcUD2W3KWRlRTomDF4FOOA1DDw3iAQ+IH7yan+E=";
    };
    aarch64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.44.11%20-%20Build%20250103fqxdt5u9z-arm64.dmg";
      hash = "sha256-0HDnRYfy+jKJy5dvaulQczAoFqYmGGWcdhIkaFZqEPA=";
    };
  };

  supportedPlatforms = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  src = sources.${buildPlatform.system};

  appimageContents = appimageTools.extractType2 {
    inherit version pname src;
  };

  wrappedAppImage = appimageTools.wrapType2 {
    inherit version pname src;
  };

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

  darwinInstallPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications/

    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/cursor"
    open -na '$APP_DIR' --args "\$@"
    EOF
    chmod +x "$out/bin/cursor"
    runHook postInstall
  '';

in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = if buildPlatform.isLinux then wrappedAppImage else null;

  dontBuild = buildPlatform.isDarwin;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional buildPlatform.isDarwin undmg;

  sourceRoot = ".";

  installPhase = if buildPlatform.isDarwin then darwinInstallPhase else appimageInstall;

  passthru = {
    inherit sources;
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl yq coreutils gnused trurl common-updater-scripts
      set -eu -o pipefail
      baseUrl="https://download.todesktop.com/230313mzl4w4u92"
      latestLinux="$(curl -s $baseUrl/latest-linux.yml)"
      latestDarwin="$(curl -s $baseUrl/latest-mac.yml)"
      linuxVersion="$(echo "$latestLinux" | yq -r .version)"

      currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

      if [[ "$linuxVersion" != "$currentVersion" ]]; then
        darwinVersion="$(echo "$latestDarwin" | yq -r .version)"
        if [ "$linuxVersion" != "$darwinVersion" ]; then
          echo "Linux version ($linuxVersion) and Darwin version ($darwinVersion) do not match"
          exit 1
        fi
        version="$linuxVersion"

        linuxFilename="$(echo "$latestLinux" | yq -r '.files[] | .url | select(. | endswith(".AppImage"))' | head -n 1)"
        linuxStem="$(echo "$linuxFilename" | sed -E s/^\(.+build.+\)-[^-]+AppImage$/\\1/)"

        darwinFilename="$(echo "$latestDarwin" | yq -r '.files[] | .url | select(. | endswith(".dmg"))' | head -n 1)"
        darwinStem="$(echo "$darwinFilename" | sed -E s/^\(.+Build[^-]+\)-.+dmg$/\\1/)"


        for platform in ${lib.escapeShellArgs supportedPlatforms}; do
          if [ $platform = "x86_64-linux" ]; then
            url="$baseUrl/$linuxStem-x86_64.AppImage"
          elif [ $platform = "aarch64-linux" ]; then
            url="$baseUrl/$linuxStem-arm64.AppImage"
          elif [ $platform = "x86_64-darwin" ]; then
            url="$baseUrl/$darwinStem-x64.dmg"
          elif [ $platform = "aarch64-darwin" ]; then
            url="$baseUrl/$darwinStem-arm64.dmg"
          else
            echo "Unsupported platform: $platform"
            exit 1
          fi

          url=$(trurl --accept-space "$url")
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
    maintainers = with lib.maintainers; [
      sarahec
      aspauldingcode
    ];
    platforms = supportedPlatforms;
    mainProgram = "cursor";
  };
}
