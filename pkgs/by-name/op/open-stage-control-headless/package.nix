{
  lib,
  stdenv,
  fetchzip,
  unzip,
  makeWrapper,
  nodejs,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open-stage-control-headless";
  version = "1.30.3";

  src = fetchzip {
    url = "https://openstagecontrol.ammd.net/packages/open-stage-control_${finalAttrs.version}_node.zip";
    hash = "sha256-ef9433pG+eMFc+7pReE2qA3hK27y5KyiRTPQ2h6Ir8A=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    python3.pkgs.python-rtmidi
  ];

  dontConfigure = true;
  dontBuild = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/open-stage-control"
    cp -r ./source/* "$out/lib/open-stage-control/"

    mkdir -p "$out/bin"
    makeWrapper ${nodejs}/bin/node "$out/bin/open-stage-control" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : ${lib.makeBinPath [ python3 ]} \
      --add-flags "$out/lib/open-stage-control"

    runHook postInstall
  '';

  meta = {
    description = "Libre and modular OSC / MIDI controller";
    homepage = "https://openstagecontrol.ammd.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = nodejs.meta.platforms;
    mainProgram = "open-stage-control";
  };
})
