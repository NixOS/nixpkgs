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
  jdk25,
  libGL,
  xorg,
  alsa-lib,
  udev,
}:

let
  version = "2026.01.14-cabac20";

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

  sources = {
    x86_64-linux = {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${version}.zip";
      hash = "sha256-14Klg+B4qUTTBWfOShvmKrv8TIrjZqhX84n1A6khSPM=";
    };
    aarch64-darwin = {
      url = "https://launcher.hytale.com/builds/release/darwin/arm64/hytale-launcher-${version}.zip";
      hash = "sha256-9jpT8GsC47qTl72sorrDxPwgEd2uwfUz2Umsi/ZLdj4=";
    };
  };

  currentSource =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  unwrapped = stdenv.mkDerivation {
    pname = "hytale-launcher-unwrapped";
    inherit version;

    src = fetchzip {
      inherit (currentSource) url hash;
      stripRoot = false;
    };

    dontStrip = true;
    dontPatchELF = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/hytale-launcher
      cp -r . $out/opt/hytale-launcher/
      chmod +x $out/opt/hytale-launcher/hytale-launcher
      runHook postInstall
    '';
  };

  fhsEnv = buildFHSEnv {
    pname = "hytale-launcher";
    inherit version;

    targetPkgs = pkgs: [
      unwrapped
      # launcher dependencies (webkit/tauri)
      pkgs.gtk3
      pkgs.nss
      pkgs.libsecret
      pkgs.libsoup_3
      pkgs.gdk-pixbuf
      pkgs.glib
      pkgs.webkitgtk_4_1
      pkgs.xdg-utils
      # java runtime for the game
      pkgs.jdk25
      # graphics
      pkgs.libGL
      # audio
      pkgs.alsa-lib
      # input/display
      pkgs.udev
      pkgs.xorg.libX11
      pkgs.xorg.libXcursor
      pkgs.xorg.libXrandr
      pkgs.xorg.libXi
      # .NET runtime dependencies :(
      pkgs.icu
      pkgs.openssl
      # misc
      pkgs.stdenv.cc.cc.lib
    ];

    runScript = "/opt/hytale-launcher/hytale-launcher";

    extraBwrapArgs = [
      "--setenv __NV_DISABLE_EXPLICIT_SYNC 1"
      "--setenv WEBKIT_DISABLE_DMABUF_RENDERER 1"
      "--setenv WEBKIT_DISABLE_COMPOSITING_MODE 1"
      "--setenv DESKTOP_STARTUP_ID com.hypixel.HytaleLauncher"
      "--setenv JAVA_HOME ${jdk25}"
    ];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    '';

    passthru.updateScript = writeScript "update-hytale-launcher" ''
      #!/usr/bin/env nix-shell
      #!nix-shell --pure -i bash -p bash curl cacert jq nix common-updater-scripts

      set -euo pipefail

      launcherJson=$(curl -s https://launcher.hytale.com/version/release/launcher.json)

      launcherJq() {
        echo "$launcherJson" | jq --raw-output "$1"
      }

      latestVersion="$(launcherJq '.version')"
      currentVersion="$(NIXPKGS_ALLOW_UNFREE=1 nix eval --impure --raw -f . hytale-launcher.version)"

      if [[ "$latestVersion" == "$currentVersion" ]]; then
        echo "package is up-to-date"
        exit 0
      fi

      update() {
        system="$1"
        url="$2"
        prefetched="$(nix-prefetch-url --unpack "$url")"
        hash="$(nix-hash --type sha256 --to-sri "$prefetched")"
        update-source-version --system="$system" --ignore-same-version hytale-launcher "$latestVersion" "$hash"
      }

      update "x86_64-linux" "$(launcherJq ".download_url.linux.amd64.url")"
      update "aarch64-darwin" "$(launcherJq ".download_url.darwin.arm64.url")"
    '';

    meta = {
      description = "Official launcher for Hytale";
      longDescription = ''
        Official launcher for Hytale, an upcoming block-based game from Hypixel Studios.

        Note: The launcher's built-in auto-update mechanism will not work on NixOS
        due to the immutable nature of the Nix store. Updates must be applied by
        updating the nixpkgs package.
      '';
      homepage = "https://hytale.com";
      license = lib.licenses.unfreeRedistributable;
      maintainers = with lib.maintainers; [ karol-broda ];
      mainProgram = "hytale-launcher";
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };

  darwinPackage = stdenv.mkDerivation {
    pname = "hytale-launcher";
    inherit version;

    src = fetchzip {
      inherit (currentSource) url hash;
      stripRoot = false;
    };

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications" "$out/bin"
      cp -r hytale-launcher.app "$out/Applications/"
      makeWrapper "$out/Applications/hytale-launcher.app/Contents/MacOS/hytale-launcher" "$out/bin/hytale-launcher"
      runHook postInstall
    '';

    passthru.updateScript = fhsEnv.passthru.updateScript;

    meta = {
      description = "Official launcher for Hytale";
      longDescription = ''
        Official launcher for Hytale, an upcoming block-based game from Hypixel Studios.

        Note: The launcher's built-in auto-update mechanism will not work on NixOS
        due to the immutable nature of the Nix store. Updates must be applied by
        updating the nixpkgs package.
      '';
      homepage = "https://hytale.com";
      license = lib.licenses.unfreeRedistributable;
      maintainers = with lib.maintainers; [ karol-broda ];
      mainProgram = "hytale-launcher";
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };

in
if stdenv.hostPlatform.isDarwin then darwinPackage else fhsEnv
