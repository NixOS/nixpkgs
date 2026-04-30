{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  ripgrep,
  sysctl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kilocode";
  version = "7.2.31";

  src = fetchFromGitHub {
    owner = "Kilo-Org";
    repo = "kilocode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0wmq4Ouy8Neb6s/sFihF6VahmQ1rgMPJDYxHx6PJNyA=";
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
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

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

    dontFixup = true;

    outputHash = "sha256-5tdpKtqI40twJN9inqnokySqx+fDbQRl/SEccFJuOWI=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    installShellFiles
    makeBinaryWrapper
    models-dev
    writableTmpDirAsHomeHook
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    # NOTE: Relax Bun version check to be a warning instead of an error.
    substituteInPlace packages/script/src/index.ts \
      --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                     'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
    substituteInPlace packages/opencode/script/build.ts \
      --replace-fail 'await $`patchelf --set-interpreter ''${interpreter} dist/''${name}/bin/kilo`' \
                     'await $`true`'
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  env.KILO_CHANNEL = "latest";
  env.KILO_VERSION = finalAttrs.version;
  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";

  buildPhase = ''
    runHook preBuild

    cd ./packages/opencode
    bun --bun ./script/build.ts --single --skip-install --skip-embed-web-ui
    bun --bun ./script/schema.ts config.json tui.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/@kilocode/cli-*/bin/kilo $out/bin/kilo
    ln -s kilo $out/bin/kilocode

    wrapProgram $out/bin/kilo \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            ripgrep
          ]
          ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
            sysctl
          ]
        )
      }

    install -Dm644 config.json $out/share/kilocode/config.json
    install -Dm644 tui.json $out/share/kilocode/tui.json

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd kilo \
      --bash <($out/bin/kilo completion) \
      --zsh <(SHELL=/bin/zsh $out/bin/kilo completion)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [
    "HOME"
    "KILO_CHANNEL"
    "KILO_VERSION"
    "MODELS_DEV_API_JSON"
  ];
  versionCheckProgram = "${placeholder "out"}/bin/kilo";
  versionCheckProgramArg = "--version";

  passthru = {
    jsonschema = {
      config = "${placeholder "out"}/share/kilocode/config.json";
      tui = "${placeholder "out"}/share/kilocode/tui.json";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "Terminal User Interface for Kilo Code";
    homepage = "https://github.com/Kilo-Org/kilocode";
    changelog = "https://github.com/Kilo-Org/kilocode/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://www.npmjs.com/package/@kilocode/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "kilo";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    badPlatforms = [
      # Broken due to Bun requiring AVX when run via Rosetta 2 on Apple Silicon.
      "x86_64-darwin"
    ];
  };
})
