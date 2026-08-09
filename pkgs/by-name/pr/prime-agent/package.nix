{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  bash,
  fd,
  git,
  gnutar,
  makeWrapper,
  nodejs,
  npm-lockfile-fix,
  python311,
  ripgrep,
  uv,
  versionCheckHook,
  xdg-utils,
}:

let
  runtimePath = [
    nodejs
    bash
    fd
    git
    ripgrep
    gnutar
    uv
    python311
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xdg-utils ];
in
buildNpmPackage (finalAttrs: {
  pname = "prime-agent";
  version = "0.9.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrimeIntellect-ai";
    repo = "prime-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RbymEr/uEQbLyo8QxMNYHidZRHAO64WE6sKM7mgm2WQ=";
    # The upstream lockfile omits registry metadata for workspace dependencies.
    postFetch = "${lib.getExe npm-lockfile-fix} $out/package-lock.json";
  };

  patches = [
    # Bootstrap runs `uv python install 3.11` explicitly when no
    # venv exists yet (bootstrap.ts), which downloads a Python that is
    # never used because the venv is created with the Python provided by nix
    # (UV_PYTHON_PREFERENCE=system). Drop the redundant download.
    ./remove-uv-python-install.patch
  ];

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-dUk0oDFErmbAS94losw6xVy+jIC+zk8/L0w1haXH4a4=";

  # Don't let `npm rebuild` run install scripts (koffi, protobufjs, @google/genai
  # all have them); they'd attempt networked or prebuilt-addon builds.
  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  # Build the workspace packages explicitly because the root package is not the CLI.
  dontNpmBuild = true;
  buildPhase = ''
    runHook preBuild

    export PATH="$PWD/node_modules/.bin:$PATH"
    npm --workspace packages/tui run build
    (cd packages/ai && tsgo -p tsconfig.build.json)
    npm --workspace packages/agent run build
    npm --workspace packages/coding-agent run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --ignore-scripts
    packageDir=$out/lib/prime-agent
    mkdir -p "$packageDir" $out/bin
    cp -R node_modules "$packageDir/node_modules"
    rm -rf "$packageDir/node_modules/koffi"
    cp packages/coding-agent/package.json "$packageDir/package.json"
    cp -R packages/coding-agent/dist "$packageDir/dist"
    for path in README.md CHANGELOG.md docs examples skills; do
      cp -R "packages/coding-agent/$path" "$packageDir/$path"
    done

    mkdir -p "$packageDir/packages"
    for workspace in ai agent tui coding-agent; do
      mkdir -p "$packageDir/packages/$workspace"
      cp "packages/$workspace/package.json" "$packageDir/packages/$workspace/package.json"
      cp -R "packages/$workspace/dist" "$packageDir/packages/$workspace/dist"
    done
    for path in docs examples skills; do
      cp -R "packages/coding-agent/$path" "$packageDir/packages/coding-agent/$path"
    done

    # The venv is created with the Python provided by nix (UV_PYTHON_PREFERENCE=system).
    # UV_PYTHON_DOWNLOADS=manual stops any surprise Python downloads.
    makeWrapper ${lib.getExe nodejs} $out/bin/prime-agent \
      --add-flags "$packageDir/dist/bundle/cli.js" \
      --set PI_PACKAGE_DIR "$packageDir" \
      --set PI_SKIP_VERSION_CHECK 1 \
      --set UV_PYTHON_PREFERENCE system \
      --set UV_PYTHON_DOWNLOADS manual \
      --prefix PATH : ${lib.makeBinPath runtimePath} \
      ${lib.optionalString stdenv.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [ stdenv.cc.cc.lib ]
      }"}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  installCheckPhase = ''
    runHook preInstallCheck

    # Verify the Python version matches what the source code requires
    requiredPythonVersion=$(grep -oP 'PYTHON_VERSION = "\K[^"]+' \
      packages/coding-agent/src/core/kernel/bootstrap.ts)
    actualVersion=$(${lib.getExe python311} -c 'import sys;print("%d.%d"%sys.version_info[:2])')
    if [ "$actualVersion" != "$requiredPythonVersion" ]; then
      echo "ERROR: prime-agent requires Python $requiredPythonVersion but $actualVersion provided"
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "Self-improving RLM coding and research agent";
    homepage = "https://github.com/PrimeIntellect-ai/prime-agent";
    changelog = "https://github.com/PrimeIntellect-ai/prime-agent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.okwilkins ];
    mainProgram = "prime-agent";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
