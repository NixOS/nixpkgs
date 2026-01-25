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
  temurin-bin-25,
  libGL,
  alsa-lib,
  udev,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  icu,
  openssl,
}:

let
  version = "2026.01.24-997c2cb";

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
      hash = "sha256-p+x+dNEhMDnjVpyzrczxP/KiYkFrbU8sqbIvwtuEN80=";
    };
    aarch64-darwin = {
      url = "https://launcher.hytale.com/builds/release/darwin/arm64/hytale-launcher-${version}.zip";
      hash = "sha256-txi54x7v4cZrlag+ICGnaLBTrpPE3Q9xeZwzFpoOYE0=";
    };
  };

  currentSource =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchzip {
    inherit (currentSource) url hash;
    stripRoot = false;
  };

  fhsEnv = buildFHSEnv {
    pname = "hytale-launcher";
    inherit version;

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
      # java runtime for the game (temurin 25 recommended by official docs)
      temurin-bin-25
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

    runScript = "${src}/hytale-launcher";

    extraBwrapArgs = [
      "--setenv __NV_DISABLE_EXPLICIT_SYNC 1"
      "--setenv WEBKIT_DISABLE_DMABUF_RENDERER 1"
      # taken from the flatpak at https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak
      "--setenv WEBKIT_DISABLE_COMPOSITING_MODE 1"
      "--setenv DESKTOP_STARTUP_ID com.hypixel.HytaleLauncher"
      "--setenv JAVA_HOME ${temurin-bin-25}"
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
      license = lib.licenses.unfreeRedistributable;
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
    inherit version src;

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
