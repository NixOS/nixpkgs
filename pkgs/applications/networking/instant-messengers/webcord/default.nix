{ lib, stdenv, buildNpmPackage, fetchFromGitHub, copyDesktopItems
, python3, pipewire, libpulseaudio, xdg-utils, electron_24, makeDesktopItem }:

buildNpmPackage rec {
  pname = "webcord";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "SpacingBat3";
    repo = "WebCord";
    rev = "v${version}";
    sha256 = "sha256-530iWNvehImwSYt5HnZaqa4TAslrwxAOZi3gRm1K2/w=";
  };

  npmDepsHash = "sha256-YguZtGn8CT4EqOQWS0GeNGBdZSC3Lj1gFR0ZiegWTJU=";

  nativeBuildInputs = [
    copyDesktopItems
    python3
  ];

  libPath = lib.makeLibraryPath [
    pipewire
    libpulseaudio
  ];

  # npm install will error when electron tries to download its binary
  # we don't need it anyways since we wrap the program with our nixpkgs electron
  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # remove husky commit hooks, errors and aren't needed for packaging
  postPatch = ''
    rm -rf .husky
  '';

  # override installPhase so we can copy the only folders that matter
  installPhase = ''
    runHook preInstall

    # Remove dev deps that aren't necessary for running the app
    npm prune --omit=dev

    mkdir -p $out/lib/node_modules/webcord
    cp -r app node_modules sources package.json $out/lib/node_modules/webcord/

    install -Dm644 sources/assets/icons/app.png $out/share/icons/hicolor/256x256/apps/webcord.png

    # Add xdg-utils to path via suffix, per PR #181171
    makeWrapper '${electron_24}/bin/electron' $out/bin/webcord \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/webcord \
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}" \
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

  meta = with lib; {
    description = "A Discord and Fosscord electron-based client implemented without Discord API";
    homepage = "https://github.com/SpacingBat3/WebCord";
    downloadPage = "https://github.com/SpacingBat3/WebCord/releases";
    changelog = "https://github.com/SpacingBat3/WebCord/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    platforms = electron_24.meta.platforms;
  };
}
