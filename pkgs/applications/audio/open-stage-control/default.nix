{ pkgs, stdenv, lib, fetchFromGitHub, makeBinaryWrapper, makeDesktopItem, copyDesktopItems, nodejs, electron, python3, ... }:

let
  nodeComposition = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in

nodeComposition.package.override rec {
  pname = "open-stage-control";
  inherit (nodeComposition.args) version;

  src = fetchFromGitHub {
    owner = "jean-emmanuel";
    repo = "open-stage-control";
    rev = "v${version}";
    hash = "sha256-q18pRtsHfme+OPmi3LhJDK1AdpfkwhoE9LA2rNenDtY=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
  ];

  buildInputs = [
    python3.pkgs.python-rtmidi
  ];

  dontNpmInstall = true;

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
  doInstallCheck = true;

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

  meta = with lib; {
    description = "Libre and modular OSC / MIDI controller";
    homepage = "https://openstagecontrol.ammd.net/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.linux;
  };
}
