{
  lib,
  stdenvNoCC,
  fetchurl,
  nodejs,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gemini-cli-bin";
  version = "0.8.1";

  src = fetchurl {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${finalAttrs.version}/gemini.js";
    hash = "sha256-SRtl8FPMI0VBz0hzmyvtGYPO3mdnm60gu2zlStb5r98=";
  };

  dontUnpack = true;

  strictDeps = true;

  buildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/bin/gemini"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];
  # versionCheckHook cannot be used because the reported version might be incorrect (e.g., 0.6.1 returns 0.6.0).
  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/gemini" -v

    runHook postInstallCheck
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
