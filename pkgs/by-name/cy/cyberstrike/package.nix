{
  lib,
  bun,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  nodejs,
  ripgrep,
  stdenvNoCC,
  sysctl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cyberstrike";
  version = "1.1.14";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "CyberStrikeus";
    repo = "CyberStrike";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MlFEGP/MiuDtLl7Ms6j11u1MdLV6w8T/7TYo7eeE/rc=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="${if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "x64"}" \
        --os="${if stdenvNoCC.hostPlatform.isLinux then "linux" else "darwin"}" \
        --filter '!./' \
        --filter './packages/cyberstrike' \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress

      bun --bun ./nix/scripts/canonicalize-node-modules.ts
      bun --bun ./nix/scripts/normalize-bun-binaries.ts

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    # Required so fixed-output derivation does not retain store references
    dontFixup = true;

    outputHash = "sha256-IxIdzd9MJJRpc0nB5eEASSW0LIckU+SvcUgkKoL+mog=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    installShellFiles
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  env = {
    MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
    CYBERSTRIKE_DISABLE_MODELS_FETCH = true;
    CYBERSTRIKE_VERSION = finalAttrs.version;
    CYBERSTRIKE_CHANNEL = "local";
  };

  buildPhase = ''
    runHook preBuild

    cd ./packages/cyberstrike
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts schema.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/cyberstrike-*/bin/cyberstrike $out/bin/cyberstrike
    install -Dm644 schema.json $out/share/cyberstrike/schema.json

    wrapProgram $out/bin/cyberstrike \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            ripgrep
            nodejs
          ]
          ++ lib.optional stdenvNoCC.hostPlatform.isDarwin sysctl
        )
      }

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd cyberstrike \
      --bash <($out/bin/cyberstrike completion) \
      --zsh <(SHELL=/bin/zsh $out/bin/cyberstrike completion)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;

  versionCheckKeepEnvironment = [
    "HOME"
    "CYBERSTRIKE_DISABLE_MODELS_FETCH"
  ];

  versionCheckProgramArg = "--version";

  passthru = {
    jsonschema = {
      config = "${placeholder "out"}/share/cyberstrike/schema.json";
      tui = "${placeholder "out"}/share/cyberstrike/tui.json";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "AI-powered offensive security agent";
    homepage = "https://github.com/CyberStrikeus/CyberStrike";
    changelog = "https://github.com/CyberStrikeus/CyberStrike/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cyberstrike";
  };
})
