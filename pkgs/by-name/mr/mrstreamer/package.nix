{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs_24,
  pnpm_11,
  pnpmConfigHook,
  electron_44,
  ffmpeg,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

let
  nodejs = nodejs_24;
  pnpm = pnpm_11;
  electron = electron_44;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mrstreamer";
  version = "0.0.20";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mr-Streamer-OSS";
    repo = "MrStreamer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4+qc1oDMh+eftiWiIsjBjC2HM8bowgqM86DeKC8NmAM=";
  };

  # Nix owns this installation: disable the in-app updater and explain this in
  # Settings. Keep this patch locally because it unconditionally identifies the
  # build as Nix-managed, which is specific to this package rather than upstream.
  patches = [ ./nix-updates.patch ];

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeWrapper
    copyDesktopItems
  ];

  pnpmWorkspaces = [ "mrstreamer..." ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-zJI/rUKvF+dW7N67W9TnrO0KBteLCdLVHQSoY1z9v74=";
  };

  # Use Nixpkgs' Electron instead of downloading a runtime through npm.
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    # Upstream sets the release version in CI rather than in the tagged manifest.
    node --input-type=module -e '
      import fs from "node:fs";
      const path = "apps/desktop/package.json";
      const manifest = JSON.parse(fs.readFileSync(path, "utf8"));
      manifest.version = "${finalAttrs.version}";
      fs.writeFileSync(path, JSON.stringify(manifest));
    '
    # Stamping the version must not trigger another dependency installation.
    export pnpm_config_verify_deps_before_run=false
    pnpm --filter mrstreamer build

    runHook postBuild
  '';

  doCheck = true;
  # Check the desktop types and patched updater. The full monorepo suite also
  # covers other applications and upstream release infrastructure.
  checkPhase = ''
    runHook preCheck
    pnpm exec tsc --noEmit -p apps/desktop
    pnpm exec tsc --noEmit -p apps/desktop/src/renderer
    pnpm exec vitest run \
      apps/desktop/test/updates.test.ts \
      apps/desktop/test/nix-installation.test.ts
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/mrstreamer"
    cp -r apps/desktop/{out,package.json} "$out/lib/mrstreamer/"
    install -Dm644 apps/desktop/build/icon.png \
      "$out/share/icons/hicolor/1024x1024/apps/mrstreamer.png"

    makeWrapper ${lib.getExe electron} "$out/bin/mrstreamer" \
      --add-flags "$out/lib/mrstreamer" \
      --set-default MR_STREAMER_FFMPEG ${lib.getExe ffmpeg} \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "mrstreamer";
      desktopName = "Mr. Streamer";
      comment = "IPTV player with live TV, movies and series";
      exec = "mrstreamer";
      icon = "mrstreamer";
      startupWMClass = "mrstreamer";
      categories = [
        "AudioVideo"
        "Player"
      ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "IPTV player with live TV, movies and series";
    homepage = "https://github.com/Mr-Streamer-OSS/MrStreamer";
    changelog = "https://github.com/Mr-Streamer-OSS/MrStreamer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _0x4bs3nt ];
    mainProgram = "mrstreamer";
    platforms = [ "x86_64-linux" ];
  };
})
