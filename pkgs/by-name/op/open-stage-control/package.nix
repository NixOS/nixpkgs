{ lib
, buildNpmPackage
, fetchFromGitHub
, makeBinaryWrapper
, makeDesktopItem
, copyDesktopItems
, nodejs_18
, electron
, python3
, nix-update-script
}:

buildNpmPackage rec {
  pname = "open-stage-control";
  version = "1.26.2";

  src = fetchFromGitHub {
    owner = "jean-emmanuel";
    repo = "open-stage-control";
    rev = "v${version}";
    hash = "sha256-hBQyz6VAtiC1XOADZml1MwGKtmdyiJNlRAmHRjt6QsA=";
  };

  # Remove some Electron stuff from package.json
  postPatch = ''
    sed -i -e '/"electron"\|"electron-installer-debian"/d' package.json
  '';

  npmDepsHash = "sha256-UqjYNXdNoQmirIgU9DRgkp14SIrawfrfi9mD2h6ACyU=";

  nodejs = nodejs_18;

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
  ];

  buildInputs = [
    python3.pkgs.python-rtmidi
  ];

  doInstallCheck = true;

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  # Override installPhase so we can copy the only directory that matters (app)
  installPhase = ''
    runHook preInstall

    # copy built app and node_modules directories
    mkdir -p $out/lib/node_modules/open-stage-control
    cp -r app $out/lib/node_modules/open-stage-control/

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Libre and modular OSC / MIDI controller";
    homepage = "https://openstagecontrol.ammd.net/";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "open-stage-control";
  };
}
