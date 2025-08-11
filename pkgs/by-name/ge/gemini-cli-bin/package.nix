{
  lib,
  stdenvNoCC,
  fetchurl,
  nodejs,
  gitUpdater,
}:
let
  owner = "google-gemini";
  repo = "gemini-cli";
  asset = "gemini.js";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gemini-cli-bin";
  version = "0.2.2";

  src = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/v${finalAttrs.version}/${asset}";
    hash = "sha256-aNLsBAygmu083L7g3EYbYH18aX1Nuljin9hV2DHeRu4=";
  };

  phases = [
    "installPhase"
    "fixupPhase"
  ];

  strictDeps = true;

  buildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/bin/gemini"

    runHook postInstall
  '';

  passthru.updateScript = [
    ./update-asset.sh
    "${owner}/${repo}"
    "${asset}"
  ];

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ljxfstorm ];
    mainProgram = "gemini";
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    priority = 10;
  };
})
