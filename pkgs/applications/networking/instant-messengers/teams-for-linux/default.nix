{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, yarn
, nodejs
, fetchYarnDeps
, prefetch-yarn-deps
, electron
, libpulseaudio
, pipewire
, alsa-utils
, which
, testers
, teams-for-linux
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teams-for-linux";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "IsmaelMartinez";
    repo = "teams-for-linux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1URS9VPqV58p8RUA47j8sdqYqps1Ruo0aqdZXedvPX8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-ef+JW5ud9LlRxaCJC2iOT5N7FgZO7IkAABJcMQPvIBA=";
  };

  patches = [
    # remove when IsmaelMartinez/teams-for-linux#1058 is merged
    (fetchpatch {
      name = "teams-for-linux-fix-version.patch";
      url = "https://github.com/IsmaelMartinez/teams-for-linux/commit/1d14947eef35c6a2e0cbdfcce405820f8dd36c68.diff";
      hash = "sha256-kj2jEAqgZ0frUw85hY23mFYFcXz95z/WQSDymsheDfg=";
    })
  ];


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
    homepage = "https://github.com/IsmaelMartinez/teams-for-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ muscaln lilyinstarlight qjoly chvp ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
