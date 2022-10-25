{ pkgs, stdenv, lib, fetchFromGitHub, makeBinaryWrapper, makeDesktopItem, copyDesktopItems, nodejs, electron, python3, ... }:

let
  nodeComposition = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in

nodeComposition.package.override rec {
  pname = "open-stage-control";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "jean-emmanuel";
    repo = "open-stage-control";
    rev = "v${version}";
    hash = "sha256-AXdPxTauy2rMRMdfUjkfTjbNDgOKmoiGUeeLak0wu84=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    nodejs
    python3
  ];

  buildInputs = [
    python3.pkgs.python-rtmidi
  ];

  doInstallCheck = true;

  preRebuild = ''
    # remove electron to prevent building since nixpkgs electron is used instead
    rm -r node_modules/electron
  '';

  postInstall = ''
    # build assets
    npm run build

    # copy icon
    install -Dm644 resources/images/logo.png $out/share/icons/hicolor/256x256/apps/open-stage-control.png
    install -Dm644 resources/images/logo.svg $out/share/icons/hicolor/scalable/apps/open-stage-control.svg

    # wrap electron and include python-rtmidi
    makeWrapper '${electron}/bin/electron' $out/bin/open-stage-control \
      --inherit-argv0 \
      --add-flags $out/lib/node_modules/open-stage-control/app \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : '${lib.makeBinPath [ python3 ]}'
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
