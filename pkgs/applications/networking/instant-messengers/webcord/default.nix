{ lib
, buildNpmPackage
, fetchFromGitHub
, copyDesktopItems
, python3
, pipewire
, libpulseaudio
, xdg-utils
, electron_28
, makeDesktopItem
, nix-update-script
}:

buildNpmPackage rec {
  pname = "webcord";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "SpacingBat3";
    repo = "WebCord";
    rev = "v${version}";
    hash = "sha256-4ePjRs9CEnDHq9iVcQNEkefl0YP/tc1ePLhW/w9NPDs=";
  };

  npmDepsHash = "sha256-UzwLORlUeTMq3RyOHpvBrbxbwgpMBsbmfyXBhpB6pOQ=";

  nativeBuildInputs = [
    copyDesktopItems
    python3
  ];

  # npm install will error when electron tries to download its binary
  # we don't need it anyways since we wrap the program with our nixpkgs electron
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # remove husky commit hooks, errors and aren't needed for packaging
  postPatch = ''
    rm -rf .husky
  '';

  # override installPhase so we can copy the only folders that matter
  installPhase =
    let
      libPath = lib.makeLibraryPath [
        libpulseaudio
        pipewire
      ];
      binPath = lib.makeBinPath [ xdg-utils ];
    in
  ''
    runHook preInstall

    # Remove dev deps that aren't necessary for running the app
    npm prune --omit=dev

    mkdir -p $out/lib/node_modules/webcord
    cp -r app node_modules sources package.json $out/lib/node_modules/webcord/

    install -Dm644 sources/assets/icons/app.png $out/share/icons/hicolor/256x256/apps/webcord.png

    # Add xdg-utils to path via suffix, per PR #181171
    makeWrapper '${lib.getExe electron_28}' $out/bin/webcord \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/webcord \
      --suffix PATH : "${binPath}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags $out/lib/node_modules/webcord/

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "webcord";
      exec = "webcord";
      icon = "webcord";
      desktopName = "WebCord";
      comment = meta.description;
      categories = [ "Network" "InstantMessaging" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Discord and SpaceBar electron-based client implemented without Discord API";
    homepage = "https://github.com/SpacingBat3/WebCord";
    downloadPage = "https://github.com/SpacingBat3/WebCord/releases";
    changelog = "https://github.com/SpacingBat3/WebCord/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "webcord";
    maintainers = with lib.maintainers; [ eclairevoyant huantian ];
    platforms = lib.platforms.linux;
  };
}
