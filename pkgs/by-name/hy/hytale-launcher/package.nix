{
  lib,
  stdenv,
  fetchzip,
  buildFHSEnv,
  makeWrapper,
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
  libGL,
  alsa-lib,
  udev,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  icu,
  openssl,
  version ? null,
  hytaleHashes ? null,
}:

let
  sources = lib.importJSON ./pin.json;

  finalVersion = if version != null then version else sources.version;
  finalHytaleHashes = if hytaleHashes != null then hytaleHashes else sources.hashes;

  # TODO: add icon once a stable versioned source is available
  desktopItem = makeDesktopItem {
    name = "hytale-launcher";
    desktopName = "Hytale Launcher";
    exec = "hytale-launcher";
    comment = "Official launcher for Hytale";
    categories = [ "Game" ];
    terminal = false;
    startupWMClass = "com.hypixel.HytaleLauncher";
  };

  os = if stdenv.hostPlatform.system == "x86_64-linux" then "linux" else "darwin";
  arch = if stdenv.hostPlatform.system == "x86_64-linux" then "amd64" else "arm64";

  src = fetchzip {
    url = "https://launcher.hytale.com/builds/release/${os}/${arch}/hytale-launcher-${finalVersion}.zip";
    hash =
      finalHytaleHashes.${stdenv.hostPlatform.system}
        or (throw "unsupported system: ${stdenv.hostPlatform.system}");
    stripRoot = false;
  };

  launcherRunScript = writeScript "hytale-launcher-run" ''
    #!/bin/bash
    LAUNCHER_DIR="$HOME/.local/share/Hytale/bin"
    LAUNCHER_BIN="$LAUNCHER_DIR/hytale-launcher"
    NIX_BIN="${src}/hytale-launcher"
    NIX_STORE_PATH_FILE="$LAUNCHER_DIR/.nix-store-path"

    if [[ ! -f "$LAUNCHER_BIN" ]] || [[ "$(cat "$NIX_STORE_PATH_FILE" 2>/dev/null)" != "$NIX_BIN" ]]; then
      mkdir -p "$LAUNCHER_DIR"
      cp "$NIX_BIN" "$LAUNCHER_BIN"
      echo "$NIX_BIN" > "$NIX_STORE_PATH_FILE"
    fi

    exec "$LAUNCHER_BIN" "$@"
  '';

  fhsEnv = buildFHSEnv {
    pname = "hytale-launcher";
    version = finalVersion;

    targetPkgs = pkgs: [
      # launcher dependencies (webkit/tauri)
      gtk3
      nss
      libsecret
      libsoup_3
      gdk-pixbuf
      glib
      webkitgtk_4_1
      xdg-utils
      # graphics
      libGL
      # audio
      alsa-lib
      # input/display
      udev
      libx11
      libxcursor
      libxrandr
      libxi
      # .NET runtime dependencies :(
      icu
      openssl
      # misc
      stdenv.cc.cc.lib
    ];

    runScript = "${launcherRunScript}";

    extraBwrapArgs = [
      "--setenv __NV_DISABLE_EXPLICIT_SYNC 1"
      "--setenv WEBKIT_DISABLE_DMABUF_RENDERER 1"
      # taken from the flatpak at https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak
      "--setenv WEBKIT_DISABLE_COMPOSITING_MODE 1"
      "--setenv DESKTOP_STARTUP_ID com.hypixel.HytaleLauncher"
    ];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    '';

    passthru = {
      inherit src;
      updateScript = ./update.sh;
    };

    meta = {
      description = "Official launcher for Hytale";
      longDescription = ''
        Official launcher for Hytale, an upcoming block-based game from Hypixel Studios.

        Note: The launcher's built-in auto-update mechanism will not work on NixOS
        due to the immutable nature of the Nix store. You may see an error message
        about "failed to remove existing executable: read-only file system", this
        is expected and the launcher will continue to work. Updates must be applied
        by updating the nixpkgs package.
      '';
      homepage = "https://hytale.com";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [
        gepbird
        karol-broda
        liquidnya
      ];
      mainProgram = "hytale-launcher";
      platforms = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };

  darwinPackage = stdenv.mkDerivation {
    pname = "hytale-launcher";
    version = finalVersion;
    inherit src;

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications" "$out/bin"
      cp -r hytale-launcher.app "$out/Applications/"
      makeWrapper "$out/Applications/hytale-launcher.app/Contents/MacOS/hytale-launcher" "$out/bin/hytale-launcher"
      runHook postInstall
    '';

    inherit (fhsEnv) passthru meta;
  };
in
if stdenv.hostPlatform.isDarwin then darwinPackage else fhsEnv
