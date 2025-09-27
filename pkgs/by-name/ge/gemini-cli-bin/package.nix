{
  lib,
  stdenvNoCC,
  fetchurl,
  nodejs,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gemini-cli-bin";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${finalAttrs.version}/gemini.js";
    hash = "sha256-jmZvL4Rst3238H2BdZ/bQuddFkFcFLRABJ1wTHm8qPM=";
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

  passthru.updateScript = nix-update-script {
    # Ignore `preview` and `nightly` tags
    extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
  };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ljxfstorm ];
    mainProgram = "gemini";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    priority = 10;
  };
})
