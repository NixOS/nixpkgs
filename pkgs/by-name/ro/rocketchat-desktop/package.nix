{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry,
  nodejs,
  pkg-config,
  node-gyp,
  python3Packages,
  electron_39,
  vips,
  xvfb-run,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
}:
let
  electron = electron_39;
in
stdenv.mkDerivation rec {
  pname = "rocketchat-desktop";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "RocketChat";
    repo = "Rocket.Chat.Electron";
    tag = version;
    hash = "sha256-ZEjhYjMcCA2ABNfcwe7JbYCoTBHr+geyMSSh6ceBt5g=";
  };

  # This might need to be updated between releases.
  # See https://nixos.org/manual/nixpkgs/stable/#javascript-yarnBerry-missing-hashes
  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-ZAb8zDdxsJYRD6LRhtFS8XRc8NbstJbUyaQCbvSdKSg=";
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    nodejs # needed for rollup
    # needed for vips compilation for the JS sharp dependency
    pkg-config
    node-gyp
    python3Packages.python
    python3Packages.distutils
    # install phase helpers
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    vips
  ];

  postPatch = ''
    # Avoid downloading a changing file during the `rollup` build
    substituteInPlace rollup.config.mjs \
      --replace-fail 'downloadSupportedVersions(),' ""
  '';

  env = {
    PUPPETEER_SKIP_DOWNLOAD = "1";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
    NODE_ENV = "production";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    # electronDist needs to be writable
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    yarn electron-builder \
        --config electron-builder.json \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  nativeCheckInputs = [
    xvfb-run
  ];

  checkPhase = "yarn test";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      categories = [
        "GNOME"
        "GTK"
        "Network"
        "InstantMessaging"
      ];
      name = pname;
      desktopName = "Rocket.Chat";
      genericName = "Rocket.Chat";
      comment = "Official Desktop Client for Rocket.Chat";
      icon = pname;
      exec = meta.mainProgram;
      terminal = false;
      startupWMClass = "Rocket.Chat";
      mimeTypes = [ "x-scheme-handler/rocketchat" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications

    cp -a dist/*-unpacked/resources $out/share/${pname}

    for icon in build/icons/*.png
    do
      install -Dm644 $icon $out/share/icons/hicolor/$(basename ''${icon%.png})/apps/${pname}.png
    done

    makeWrapper '${lib.getExe electron}' $out/bin/${meta.mainProgram} \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags $out/share/${pname}/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official Desktop client for Rocket.Chat";
    mainProgram = "rocketchat-desktop";
    homepage = "https://github.com/RocketChat/Rocket.Chat.Electron";
    changelog = "https://github.com/RocketChat/Rocket.Chat.Electron/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mynacol ];
    platforms = lib.platforms.linux;
  };
}
