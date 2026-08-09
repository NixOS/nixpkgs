{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  autoPatchelfHook,
  bash,
  cairo,
  fd,
  git,
  gnutar,
  makeWrapper,
  nodejs_26,
  npm-lockfile-fix,
  pango,
  pkg-config,
  python311,
  ripgrep,
  uv,
  versionCheckHook,
  xdg-utils,
}:

let
  runtimePath = [
    nodejs_26
    bash
    fd
    git
    ripgrep
    gnutar
    uv
    python311
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xdg-utils ];

  # Keep only the host platform binaries shipped by ZeroMQ's npm package.
  zeroMqOS = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
  zeroMqArch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x64";
  zeroMqCleanupPhase = ''
    find "$packageDir/node_modules/zeromq/build" \
      -mindepth 1 -maxdepth 1 -type d ! -name "${zeroMqOS}" \
      -exec rm -rf {} +
    find "$packageDir/node_modules/zeromq/build/${zeroMqOS}" \
      -mindepth 1 -maxdepth 1 -type d ! -name "${zeroMqArch}" \
      -exec rm -rf {} +
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    find "$packageDir/node_modules/zeromq/build/linux/${zeroMqArch}/node" \
      -mindepth 1 -maxdepth 1 -type d -name 'musl-*' \
      -exec rm -rf {} +
  '';
in
buildNpmPackage (finalAttrs: {
  pname = "prime-agent";
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrimeIntellect-ai";
    repo = "prime-agent";
    rev = "be9e2fa0714e7cd1c6bd9bdb1b554d2cc6550387";
    hash = "sha256-I386TWwpO2Ac005xpPIur92BYviTATbPJ5hKznpDrr8=";
    # The upstream lockfile omits registry metadata for workspace dependencies.
    postFetch = "${lib.getExe npm-lockfile-fix} $out/package-lock.json";
  };

  nodejs = nodejs_26;
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-P6jX/qRm/Uk1Vmj/MzAUc9Oax91SJAbUkB7Q8qhH0qA=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    cairo
    pango
  ];

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

    ${zeroMqCleanupPhase}

    makeWrapper ${lib.getExe nodejs_26} $out/bin/prime-agent \
      --add-flags "$packageDir/dist/bundle/cli.js" \
      --set PI_PACKAGE_DIR "$packageDir" \
      --set PI_SKIP_VERSION_CHECK 1 \
      --set UV_PYTHON_PREFERENCE system \
      --set UV_PYTHON_DOWNLOADS never \
      --prefix PATH : ${lib.makeBinPath runtimePath} \
      ${lib.optionalString stdenv.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [ stdenv.cc.cc.lib ]
      }"}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
