{ lib, buildNpmPackage, fetchFromGitHub, makeBinaryWrapper, makeDesktopItem, copyDesktopItems, electron, python3 }:

buildNpmPackage rec {
  pname = "open-stage-control";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "jean-emmanuel";
    repo = "open-stage-control";
    rev = "v${version}";
    hash = "sha256-XgwlRdwUSl4gIRKqk6BnMAKarVvp291zk8vmNkuRWKo=";
  };

  patches = [
    # Use generated package-lock.json since upstream does not provide one in releases
    ./package-lock.json.patch
  ];

  npmDepsHash = "sha256-SGLcFjPnmhFoeXtP4gfGr4Qa1dTaXwSnzkweEvYW/1k=";

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    python3
  ];

  buildInputs = [
    python3.pkgs.python-rtmidi
  ];

  doInstallCheck = true;

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  # Override installPhase so we can copy the only folders that matter (app and node_modules)
  installPhase = ''
    runHook preInstall

    # prune unused deps
    npm prune --omit dev $npmFlags

    # copy built app and node_modules directories
    mkdir -p $out/lib/node_modules/open-stage-control
    cp -r app node_modules $out/lib/node_modules/open-stage-control/

    # copy icon
    install -Dm644 resources/images/logo.png $out/share/icons/hicolor/256x256/apps/open-stage-control.png
    install -Dm644 resources/images/logo.svg $out/share/icons/hicolor/scalable/apps/open-stage-control.svg

    # wrap electron and include python-rtmidi
    makeWrapper '${electron}/bin/electron' $out/bin/open-stage-control \
      --inherit-argv0 \
      --add-flags $out/lib/node_modules/open-stage-control/app \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : '${lib.makeBinPath [ python3 ]}'

    runHook postInstall
  '';

  installCheckPhase = ''
    XDG_CONFIG_HOME="$(mktemp -d)" $out/bin/open-stage-control --help
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "open-stage-control";
      exec = "open-stage-control";
      icon = "open-stage-control";
      desktopName = "Open Stage Control";
      comment = meta.description;
      categories = [ "Network" "Audio" "AudioVideo" "Midi" ];
      startupWMClass = "open-stage-control";
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Libre and modular OSC / MIDI controller";
    homepage = "https://openstagecontrol.ammd.net/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.linux;
  };
}
