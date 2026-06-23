{
  lib,
  stdenv,
  buildNpmPackage,
  copyDesktopItems,
  electron_40,
  fetchFromGitHub,
  jq,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  nodejs_24,
}:

let
  electron = electron_40;
  nodejs = nodejs_24;
  description = "Cross-platform desktop app for managing periodic breaks";
in
buildNpmPackage rec {
  pname = "breaktimer";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "tom-james-watson";
    repo = "breaktimer-app";
    tag = "v${version}";
    hash = "sha256-STDb6+brlVk/ZPUbw3cQOpe2r03WlFKEBgVLqJrsrHI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # electron-updater's auto-install path tries to download a new release
  # from GitHub and overwrite the nix-store binary, which is read-only.
  # Updates come via nix instead.
  patches = [ ./disable-auto-update.patch ];

  # The package ships a lockfile (package-lock.json) but the default
  # `npm run build` is run via `concurrently`; we drive the build manually.
  dontNpmBuild = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmDepsHash = "sha256-UL8e0UKZKhHHC+JvRpmcdBvFHlCdn3YknceVJ+knMgg=";

  nativeBuildInputs = [
    jq
    nodejs
    makeWrapper
    copyDesktopItems
  ];

  preBuild = ''
    if [[ $(jq --raw-output '.devDependencies.electron' < package.json | grep -E --only-matching '\^[0-9]+' | sed -e 's/\^//') != ${lib.escapeShellArg (lib.versions.major electron.version)} ]]; then
      echo 'ERROR: electron version mismatch'
      exit 1
    fi
  '';

  buildPhase = ''
    runHook preBuild

    npm run build

    # electron-builder needs to mutate the copied Electron.app, which is
    # read-only in the nix store. Copy it to a writable location first.
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # Produce an unpacked Electron app without code-signing / notarisation.
    npm exec electron-builder -- \
      --dir \
      --c.electronDist=electron-dist \
      --c.electronVersion=${electron.version} \
      --c.mac.identity=null \
      --c.mac.notarize=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    unpacked="release/linux-${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64-"}unpacked"

    mkdir -p "$out/share/lib/breaktimer"
    cp -r "$unpacked"/{locales,resources{,.pak}} "$out/share/lib/breaktimer"

    makeWrapper '${lib.getExe electron}' "$out/bin/breaktimer" \
      --add-flags "$out/share/lib/breaktimer/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    install -Dm644 resources/icon.png \
      "$out/share/icons/hicolor/512x512/apps/breaktimer.png"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -R release/mac-*/BreakTimer.app "$out/Applications/"

    mkdir -p "$out/bin"
    makeWrapper \
      "$out/Applications/BreakTimer.app/Contents/MacOS/BreakTimer" \
      "$out/bin/breaktimer" \
      --set-default ELECTRON_IS_DEV 0
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "breaktimer";
      exec = "breaktimer";
      icon = "breaktimer";
      comment = description;
      desktopName = "BreakTimer";
      genericName = "Break Reminder";
      categories = [
        "Utility"
        "Office"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit description;
    homepage = "https://github.com/tom-james-watson/breaktimer-app";
    changelog = "https://github.com/tom-james-watson/breaktimer-app/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ proitheus ];
    mainProgram = "breaktimer";
    platforms = electron.meta.platforms;
  };
}
