{
  lib,
  callPackage,
  stdenv,
  fetchFromGitHub,
  # Pinned, because our FODs are not guaranteed to be stable between major versions.
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  python3,
  makeWrapper,
  # Electron updates can break Heroic, so try to use same version as upstream.
  # If the used electron version is higher than upstream's then the node-abi package might need to be updated
  electron_39,
  vulkan-helper,
  gogdl,
  nile,
  comet-gog_heroic,
  umu-launcher,
}:

let
  pnpm = pnpm_10;
  electron = electron_39;

  legendary = callPackage ./legendary.nix { };
  epic-integration = callPackage ./epic-integration.nix { };
  comet-gog = comet-gog_heroic;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "heroic-unwrapped";
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "HeroicGamesLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e+/FRvG9u6ZQsMGD5hqY+yLPjsbLSrjC9Wp0xdxVk6w=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-uwJYOm+2wGNRHAiIw1UjCBLBW6kjtj6AFLWihCqtL28=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    python3
    makeWrapper
  ];

  patches = [
    # Make Heroic create Steam shortcuts (to non-steam games) with the correct path to heroic.
    ./fix-non-steam-shortcuts.patch
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    # set nodedir to prevent node-gyp from downloading headers
    export npm_config_nodedir=${electron.headers}

    pnpm --offline electron-vite build
    pnpm --offline electron-builder \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  # --disable-gpu-compositing is to work around upstream bug
  # https://github.com/electron/electron/issues/32317
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/heroic"
    cp -r dist/linux-unpacked/resources "$out/opt/heroic"

    bin_dir="$out/opt/heroic/resources/app.asar.unpacked/build/bin"

    # Clean up prebuilt binaries
    rm -r "$bin_dir"
    mkdir -p "$bin_dir/x64/linux/" "$bin_dir/x64/win32/"

    ln -s \
      "${lib.getExe gogdl}" \
      "${lib.getExe legendary}" \
      "${lib.getExe nile}" \
      "${lib.getExe comet-gog}" \
      "${lib.getExe vulkan-helper}" \
      "$bin_dir/x64/linux/"

    # Don't symlink these so we don't confuse Windows applications under Wine/Proton.
    cp \
      "${comet-gog.dummy-service}/GalaxyCommunication.exe" \
      "${epic-integration}/EpicGamesLauncher.exe" \
      "$bin_dir/x64/win32/"

    makeWrapper "${lib.getExe electron}" "$out/bin/heroic" \
      --inherit-argv0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --suffix PATH ":" "${umu-launcher}/bin" \
      --add-flags --disable-gpu-compositing \
      --add-flags $out/opt/heroic/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -D "flatpak/com.heroicgameslauncher.hgl.desktop" "$out/share/applications/com.heroicgameslauncher.hgl.desktop"
    install -D "src/frontend/assets/heroic-icon.svg" "$out/share/icons/hicolor/scalable/apps/com.heroicgameslauncher.hgl.svg"
    substituteInPlace "$out/share/applications/com.heroicgameslauncher.hgl.desktop" \
      --replace-fail "Exec=heroic-run --ozone-platform-hint=auto" "Exec=heroic"

    runHook postInstall
  '';

  passthru = {
    inherit epic-integration legendary;
  };

  meta = {
    description = "Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    changelog = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      tomasajt
      iedame
      keenanweaver
      DieracDelta
      baksa
    ];
    # Heroic may work on nix-darwin, but it needs a dedicated maintainer for the platform.
    # It may also work on other Linux targets, but all the game stores only
    # support x86 Linux, so it would require extra hacking to run games via QEMU
    # user emulation.  Upstream provide Linux builds only for x86_64.
    platforms = [ "x86_64-linux" ];
    mainProgram = "heroic";
  };
})
