{
  lib,
  writeShellApplication,

  coreutils,
  curl,
  flatpak,
  libnotify,

  copyDesktopItems,
  makeDesktopItem,

  extraEnvironment ? { },
  ...
}:
let
  environment = {
    __NV_DISABLE_EXPLICIT_SYNC = "1";
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
    DESKTOP_STARTUP_ID = "com.hypixel.HytaleLauncher";
  }
  // extraEnvironment;
  toFlatpakEnvArg = (var: lib.escapeShellArg "--env=${var.name}=${var.value}");
in
writeShellApplication {
  name = "hytale-launcher";

  runtimeInputs = [
    coreutils
    curl
    flatpak
    libnotify
  ];

  text = ''
    if ! flatpak info --user com.hypixel.HytaleLauncher >/dev/null 2>&1; then
      notify-send "Hytale Launcher" "[Nix] Installing Hytale Launcher for the first time with Flatpak..." || true

      logs="$(mktemp /tmp/nix-hytale-launcher-XXXXX.log || true)"

      if ! (
        tmp="$(mktemp /tmp/XXXXX.flatpak)" &&
          curl -o "$tmp" https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak &&
          flatpak install --user --noninteractive --bundle "$tmp"
      ) 2>&1 | tee "$logs"; then
        notify-send "Hytale Launcher" "[Nix] Installing Hytale Launcher for failed! Logs in $logs"
        exit 1
      fi
    fi

    flatpak run --user \
      ${lib.concatMapStringsSep " " toFlatpakEnvArg (lib.attrsToList environment)} \
      com.hypixel.HytaleLauncher
  '';

  derivationArgs = {
    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [ copyDesktopItems ];
    desktopItems = lib.singleton (makeDesktopItem {
      name = "com.hypixel.HytaleLauncher";
      desktopName = "Hytale Launcher";
      genericName = "Launcher for sandbox block game";
      exec = "hytale-launcher";
      categories = [ "Game" ];
      startupWMClass = "com.hypixel.HytaleLauncher";
    });

    # HACK: writeShellApplication doesn't run all phases by default, so we
    # inject installPhase in checkPhase...
    postCheck = "runPhase installPhase";

    meta = {
      description = "Official launcher for Hytale";
      longDescription = ''
        Official launcher for Hytale, an upcoming block-based game from Hypixel Studios.

        NOTE: This package is a simply a script which downloads and installs
        the Hytale launcher flatpak at *runtime*. From the first install, the
        launcher version is managed entirely by the Hytale launcher itself,
        meaning this package is **not reproducible**.

        See discussions on [this pull request](https://github.com/NixOS/nixpkgs/pull/479368)
        for more context on why this method was chosen.
      '';
      homepage = "https://hytale.com";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [
        gepbird
        karol-broda
        liquidnya
        dtomvan
      ];
      mainProgram = "hytale-launcher";
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
}
