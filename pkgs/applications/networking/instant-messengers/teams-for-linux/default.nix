{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fixup_yarn_lock
, yarn
, nodejs
, fetchYarnDeps
, electron
}:

stdenv.mkDerivation rec {
  pname = "teams-for-linux";
  version = "1.0.45";

  src = fetchFromGitHub {
    owner = "IsmaelMartinez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q6DFegFrLUW/YiRyYJI4ITVVyMC5IkazlzhdR8203cY=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-jaAieO5q+tNfWN7Rp6ueasl45cfp9W1QxPdqIeCnVkE=";
  };

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
      --dir --linux ${if stdenv.hostPlatform.isAarch64 then "--arm64" else "--x64"} \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,teams-for-linux}
    cp dist/linux-${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64-"}unpacked/resources/app.asar $out/share/teams-for-linux/

    pushd build/icons
    for image in *png; do
      mkdir -p $out/share/icons/hicolor/''${image%.png}/apps
      cp -r $image $out/share/icons/hicolor/''${image%.png}/apps/teams-for-linux.png
    done
    popd

    makeWrapper '${electron}/bin/electron' "$out/bin/teams-for-linux" \
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

  meta = with lib; {
    description = "Unofficial Microsoft Teams client for Linux";
    homepage = "https://github.com/IsmaelMartinez/teams-for-linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ muscaln ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
