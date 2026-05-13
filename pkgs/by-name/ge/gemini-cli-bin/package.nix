{
  lib,
  stdenvNoCC,
  fetchzip,
  nodejs,
  sysctl,
  writableTmpDirAsHomeHook,
  nix-update-script,
  ripgrep,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gemini-cli-bin";
  version = "0.42.0";

  src = fetchzip {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${finalAttrs.version}/gemini-cli-bundle.zip";
    hash = "sha256-Qkb39ehFabpRGxqpl3wCzoK3A2z5TMnKswngLz6kP/s=";
    stripRoot = false;
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    nodejs
    ripgrep
  ];

  patchPhase = ''
    runHook prePatch

    # chunk filenames contain unpredictable hashes, use glob to iterate
    for chunk in ./chunk-*.js; do

      # disable auto-update
      if grep -q 'enableAutoUpdate: {' "$chunk"; then
        sed -i '/enableAutoUpdate: {/,/}/ s/default: true/default: false/' "$chunk"
      fi

      # use `ripgrep` from `nixpkgs`, more dependencies but prevent downloading incompatible binary on NixOS
      # this workaround can be removed once the following upstream issue is resolved:
      # https://github.com/google-gemini/gemini-cli/issues/11438
      if grep -q 'await resolveExistingRgPath();' "$chunk"; then
        substituteInPlace "$chunk" \
          --replace-fail 'const existingPath = await resolveExistingRgPath();' 'const existingPath = "${lib.getExe ripgrep}";'
      fi

    done

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    local bundleDir="$out/lib/gemini"

    mkdir -p "$bundleDir"
    cp -aT . "$bundleDir"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/gemini" \
      --add-flags "--no-warnings=DEP0040" \
      --add-flags "$bundleDir/gemini.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals (with stdenvNoCC.hostPlatform; isDarwin && isx86_64) [
    sysctl
  ];

  # versionCheckHook cannot be used because it assumes the executable is hermetic,
  # but we need `nativeInstallCheckInputs`
  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/gemini" -v | grep "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

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
