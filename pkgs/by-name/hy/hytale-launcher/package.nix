{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  writeScript,
  gtk3,
  nss,
  libsecret,
  libsoup_3,
  gdk-pixbuf,
  glib,
  webkitgtk_4_1,
  xdg-utils,
}:

let
  version = "2026.01.12-e43ec47";

  sources = {
    x86_64-linux = {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${version}.zip";
      hash = "sha256-OtfhmPQPmmrwp/1XYcbefj6PMxEEbOE5RSTECCZaguc=";
    };
    aarch64-darwin = {
      url = "https://launcher.hytale.com/builds/release/darwin/arm64/hytale-launcher-${version}.zip";
      hash = "sha256-2+RCO1dqK6AGSPy/tFVvMeETUuuughwNznvGENPobew=";
    };
  };

  currentSource =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hytale-launcher";
  inherit version;

  src = fetchzip {
    inherit (currentSource) url hash;
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    nss
    libsecret
    libsoup_3
    gdk-pixbuf
    glib
    webkitgtk_4_1
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "hytale-launcher";
      exec = "hytale-launcher";
      desktopName = "Hytale Launcher";
      categories = [ "Game" ];
      terminal = false;
    })
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p "$out/bin"

    install -Dm755 "hytale-launcher" "$out/bin/hytale-launcher"

    wrapProgram "$out/bin/hytale-launcher" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --set __NV_DISABLE_EXPLICIT_SYNC 1 \
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
      --set DESKTOP_STARTUP_ID com.hypixel.HytaleLauncher
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications" "$out/bin"
    cp -r hytale-launcher.app "$out/Applications/"
    makeWrapper "$out/Applications/hytale-launcher.app/Contents/MacOS/hytale-launcher" "$out/bin/hytale-launcher"
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript =
    writeScript "update-hytale-launcher" # sh
      ''
        #!/usr/bin/env nix-shell
        #!nix-shell --pure -i bash -p bash curl cacert jq nix common-updater-scripts

        set -euo pipefail

        launcherJson=$(curl -s https://launcher.hytale.com/version/release/launcher.json)

        launcherJq() {
          echo "$launcherJson" | jq --raw-output "$1"
        }

        latestVersion="$(launcherJq '.version')"
        currentVersion="$(NIXPKGS_ALLOW_UNFREE=1 nix eval --impure --raw -f . ${finalAttrs.pname}.version)"

        if [[ "$latestVersion" == "$currentVersion" ]]; then
          echo "package is up-to-date"
          exit 0
        fi

        update() {
          system="$1"
          url="$2"
          prefetched="$(nix-prefetch-url --unpack "$url")"
          hash="$(nix-hash --type sha256 --to-sri "$prefetched")"
          update-source-version --system="$system" --ignore-same-version ${finalAttrs.pname} "$latestVersion" "$hash"
        }

        update "x86_64-linux" "$(launcherJq ".download_url.linux.amd64.url")"
        update "aarch64-darwin" "$(launcherJq ".download_url.darwin.arm64.url")"
      '';

  meta = {
    description = "Official launcher for Hytale";
    homepage = "https://hytale.com";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ karol-broda ];
    mainProgram = "hytale-launcher";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
