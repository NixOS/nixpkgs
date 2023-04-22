{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, yarn
, nodejs
, fetchYarnDeps
, fixup_yarn_lock
, electron
, libpulseaudio
, pipewire
, alsa-utils
, which
}:

stdenv.mkDerivation rec {
  pname = "teams-for-linux";
  version = "1.0.65";

  src = fetchFromGitHub {
    owner = "IsmaelMartinez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Rj6A1h5R4w8zacoTV0WKTbTD67qwsw4zHP+KQ6h7/gs=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = "sha256-3zjmVIPQ+F2jPQ2xkAv5hQUjr8k5jIHTsa73J+IMayw=";
  };

  patches = [
    # Can be removed once Electron upstream resolves https://github.com/electron/electron/issues/36660
    ./screensharing-wayland-hack-fix.patch
  ];

  nativeBuildInputs = [ yarn fixup_yarn_lock nodejs copyDesktopItems makeWrapper ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline electron-builder \
      --dir ${if stdenv.isDarwin then "--macos" else "--linux"} ${if stdenv.hostPlatform.isAarch64 then "--arm64" else "--x64"} \
      -c.electronDist=${electron}/lib/electron \
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

    # Linux needs 'aplay' for notification sounds, 'libpulse' for meeting sound, and 'libpipewire' for screen sharing
    makeWrapper '${electron}/bin/electron' "$out/bin/teams-for-linux" \
      ${lib.optionalString stdenv.isLinux ''
        --prefix PATH : ${lib.makeBinPath [ alsa-utils which ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio pipewire ]} \
      ''} \
      --add-flags "$out/share/teams-for-linux/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  desktopItems = [(makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = "Microsoft Teams for Linux";
    comment = meta.description;
    categories = [ "Network" "InstantMessaging" "Chat" ];
  })];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Unofficial Microsoft Teams client for Linux";
    homepage = "https://github.com/IsmaelMartinez/teams-for-linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ muscaln lilyinstarlight ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
