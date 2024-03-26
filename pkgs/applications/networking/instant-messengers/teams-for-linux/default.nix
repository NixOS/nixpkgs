{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, yarn
, nodejs
, fetchYarnDeps
, prefetch-yarn-deps
, electron
, libnotify
, libpulseaudio
, pipewire
, alsa-utils
, which
, testers
, teams-for-linux
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teams-for-linux";
  version = "1.4.14";

  src = fetchFromGitHub {
    owner = "IsmaelMartinez";
    repo = "teams-for-linux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qdox6C6ztWECwSqHZoZHMbqPFrokPK0u44NUG+SHmPk=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-++ZPsBH0qHCykexpY2aZukAc+Ak1wEzAUker8ZLxA9Q=";
  };

  nativeBuildInputs = [ yarn prefetch-yarn-deps nodejs copyDesktopItems makeWrapper ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline electron-builder \
      --dir ${if stdenv.isDarwin then "--macos" else "--linux"} ${if stdenv.hostPlatform.isAarch64 then "--arm64" else "--x64"} \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,teams-for-linux}
    cp dist/${if stdenv.isDarwin then "darwin-" else "linux-"}${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64-"}unpacked/resources/app.asar $out/share/teams-for-linux/

    pushd build/icons
    for image in *png; do
      mkdir -p $out/share/icons/hicolor/''${image%.png}/apps
      cp -r $image $out/share/icons/hicolor/''${image%.png}/apps/teams-for-linux.png
    done
    popd

    # Linux needs 'aplay' for notification sounds, 'libpulse' for meeting sound, 'libpipewire' for screen sharing and 'libnotify' for notifications
    makeWrapper '${electron}/bin/electron' "$out/bin/teams-for-linux" \
      ${lib.optionalString stdenv.isLinux ''
        --prefix PATH : ${lib.makeBinPath [ alsa-utils which ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio pipewire libnotify ]} \
      ''} \
      --add-flags "$out/share/teams-for-linux/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  desktopItems = [(makeDesktopItem {
    name = finalAttrs.pname;
    exec = finalAttrs.pname;
    icon = finalAttrs.pname;
    desktopName = "Microsoft Teams for Linux";
    comment = finalAttrs.meta.description;
    categories = [ "Network" "InstantMessaging" "Chat" ];
  })];

  passthru.updateScript = ./update.sh;
  passthru.tests.version = testers.testVersion rec {
    package = teams-for-linux;
    command = "HOME=$TMPDIR ${package.meta.mainProgram or package.pname} --version";
  };

  meta = {
    description = "Unofficial Microsoft Teams client for Linux";
    mainProgram = "teams-for-linux";
    homepage = "https://github.com/IsmaelMartinez/teams-for-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ muscaln lilyinstarlight qjoly chvp ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
