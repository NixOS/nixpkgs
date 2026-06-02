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
  version = "0.49.0";

  src = fetchzip {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${finalAttrs.version}/gemini-cli-bundle.zip";
    hash = "sha256-R7Lg9xCzyqAria0FyZmwzeLr1K0A/gw40c+rmOPwn5A=";
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

    chunkCount=0
    autoUpdatePatches=0
    rgCandidatePathPatches=0
    trustedPrefixPatches=0

    # Chunk filenames contain unpredictable hashes, use glob to iterate
    for chunk in ./chunk-*.js; do

      chunkCount=$((chunkCount + 1))

      # Disable auto-update
      if sed -n '/enableAutoUpdate: {/,/}/p' "$chunk" | grep -Fq 'default: true'; then
        sed -i '/enableAutoUpdate: {/,/}/ s/default: true/default: false/' "$chunk"
        autoUpdatePatches=$((autoUpdatePatches + 1))
      fi

      # Prefer the Nix ripgrep binary by prepending it to candidate paths
      if grep -Fq 'const candidatePaths = [' "$chunk"; then
        substituteInPlace "$chunk" --replace-fail \
          'const candidatePaths = [' 'const candidatePaths = ["${lib.getExe ripgrep}", '
        rgCandidatePathPatches=$((rgCandidatePathPatches + 1))
      fi

      # Trust the Nix store path by adding it to standard system prefixes
      if grep -Fq 'const trustedPrefixes = [' "$chunk"; then
        substituteInPlace "$chunk" --replace-fail \
          'const trustedPrefixes = [' 'const trustedPrefixes = ["/nix/store", '
        trustedPrefixPatches=$((trustedPrefixPatches + 1))
      fi

    done

    if (( chunkCount == 0 )); then
      echo "error: no chunk files found" >&2
      exit 1
    fi

    if (( autoUpdatePatches == 0 )); then
      echo "error: failed to patch auto-update default" >&2
      exit 1
    fi

    if (( rgCandidatePathPatches == 0 )); then
      echo "error: failed to patch ripgrep candidate paths" >&2
      exit 1
    fi

    if (( trustedPrefixPatches == 0 )); then
      echo "error: failed to patch trusted prefixes" >&2
      exit 1
    fi

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
