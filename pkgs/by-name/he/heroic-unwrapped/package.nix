{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  nix-update-script,

  # Pinned, because our FODs are not guaranteed to be stable between major versions.
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  makeWrapper,
  desktop-file-utils,
  writableTmpDirAsHomeHook,

  # Electron updates can break Heroic, so try to use same version as upstream.
  # If the used electron version is higher than upstream's then the node-abi package might need to be updated
  electron_43,

  # Helper versions: RELEASE_TAGS in upstream meta/downloadHelperBinaries.ts
  comet-gog_heroic,
  gogdl,
  legendary-gl,
  nile,
  umu-launcher,
  vulkan-helper,
}:

let
  pnpm = pnpm_12;
  electron = electron_43;
  appId = "com.heroicgameslauncher.hgl";

  epic-integration = callPackage ./epic-integration.nix { };

  # Heroic looks up helpers by Node's arch name (x64, arm64).
  helpersDir = "$out/share/heroic/resources/app.asar.unpacked/build/bin";
  linuxHelpersDir = "${helpersDir}/${stdenv.hostPlatform.node.arch}/linux";
  linuxHelpers = lib.concatMapStringsSep " " lib.getExe [
    comet-gog_heroic
    gogdl
    legendary-gl
    nile
    vulkan-helper
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "heroic-unwrapped";
  version = "2.22.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "HeroicGamesLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3P2u2Pzle3KpYPehfJXGrqg3OAxUrTIlUH3yiWBDPpg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-ffvwX+R4b8VezeJiKR9k3kRhf2tVXTUGUFw606lKL9A=";
  };

  patches = [
    # Make Heroic create Steam shortcuts (to non-steam games) with the correct path to heroic.
    ./fix-non-steam-shortcuts.patch
    ./fix-notification-name.patch
  ];

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
    desktop-file-utils
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Stop the electron npm package from downloading its binary; we use nixpkgs' electron.
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    pnpm --offline build
    # npmRebuild: Heroic has no native modules, so skip rebuilding them for electron.
    pnpm --offline electron-builder \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.extraMetadata.desktopName=${appId}.desktop \
      -c.npmRebuild=false

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    # Tests create directories two levels above tmpdir(), so use the hook's nested $HOME.
    export TMPDIR="$HOME"
    pnpm --offline test:ci

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    # Skip default_app.asar and app-update.yml; unused with nixpkgs' electron.
    mkdir -p $out/share/heroic/resources
    cp -r dist/*-unpacked/resources/app.asar{,.unpacked} $out/share/heroic/resources

    runHook postInstall
  '';

  postInstall = ''
    # Upstream's desktop file targets the Flatpak's heroic-run wrapper.
    desktop-file-install --dir $out/share/applications \
      --set-key=Exec --set-value="heroic %u" \
      --set-key=StartupWMClass --set-value=${appId} \
      flatpak/${appId}.desktop
    install -Dm644 src/frontend/assets/heroic-icon.svg $out/share/icons/hicolor/scalable/apps/${appId}.svg
    install -Dm644 flatpak/${appId}.png $out/share/icons/hicolor/128x128/apps/${appId}.png

    # Replace the bundled helper binaries with ours.
    rm -r ${helpersDir}
    install -d ${linuxHelpersDir} ${helpersDir}/x64/win32
    ln -st ${linuxHelpersDir} ${linuxHelpers}

    # Copied, not symlinked, so Windows programs under Wine/Proton aren't confused.
    cp -t ${helpersDir}/x64/win32 \
      ${comet-gog_heroic.dummy-service}/GalaxyCommunication.exe \
      ${epic-integration}/EpicGamesLauncher.exe
  '';

  makeWrapperArgs = [
    "--inherit-argv0"
    "--set"
    "ELECTRON_FORCE_IS_PACKAGED"
    "1"
    "--add-flags"
    "${placeholder "out"}/share/heroic/resources/app.asar"
    "--add-flags"
    # Electron >= 38 runs natively on Wayland by default, so don't gate on NIXOS_OZONE_WL.
    "\${WAYLAND_DISPLAY:+--enable-features=WaylandWindowDecorations --enable-wayland-ime=true}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [ umu-launcher ])
  ];

  postFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/heroic "''${makeWrapperArgs[@]}"
  '';

  passthru = {
    inherit epic-integration;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac";
    homepage = "https://heroicgameslauncher.com/";
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
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "heroic";
  };
})
