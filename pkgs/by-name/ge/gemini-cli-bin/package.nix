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
  version = "0.18.4";

  src = fetchurl {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${finalAttrs.version}/gemini.js";
    hash = "sha256-hKtmIGysnJ2zlpfpd6W2yA2OqPwQW2xdaND6jMe7lgs=";
  };

  dontUnpack = true;

  strictDeps = true;

  buildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/bin/gemini"

    # ideal method to disable auto-update
    sed -i '/disableautoupdate: {/,/}/ s/default: false/default: true/' "$out/bin/gemini"

    # disable auto-update for real because the default value in settingsschema isn't cleanly applied
    # https://github.com/google-gemini/gemini-cli/issues/13569
    substituteInPlace $out/bin/gemini \
      --replace-fail "settings.merged.general?.disableUpdateNag" "(settings.merged.general?.disableUpdateNag ?? true)" \
      --replace-fail "settings.merged.general?.disableAutoUpdate ?? false" "settings.merged.general?.disableAutoUpdate ?? true" \
      --replace-fail "settings.merged.general?.disableAutoUpdate" "(settings.merged.general?.disableAutoUpdate ?? true)"

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
