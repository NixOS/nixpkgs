{
  lib,
  stdenv,
  bun,
  darwin,
  fetchFromGitHub,
  makeBinaryWrapper,
  models-dev,
  nodejs,
  nix-update-script,
  ripgrep,
  runCommand,
  sysctl,
  jq,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  node_modules =
    finalAttrs:
    stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

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
          --filter ./ \
          --filter ./packages/app \
          --filter ./packages/desktop \
          --filter ./packages/opencode \
          --filter ./packages/shared \
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
        find $out -type f -name '*.exe' -delete

        runHook postInstall
      '';

      dontFixup = true;

      outputHash = "sha256-o2FEfe3kBNi7trdMnX17Kd6Dm9IFCadET7w0vs+kNhU=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode-vim";
  version = "1.18.35-ocv.4.13";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "leohenon";
    repo = "opencode-vim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RgN6uQUe0X8ANyB94fMoelBHjsvmErbl8GVRFf5Plnw=";
  };

  # Use the packaged Bun version, and run the smoke check after fixup instead.
  postPatch = ''
    substituteInPlace packages/script/src/index.ts \
      --replace-fail \
      'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
      'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
  ''
  + ''
    substituteInPlace packages/opencode/script/build.ts \
      --replace-fail \
      'if (item.os === process.platform && item.arch === process.arch && !item.abi)' \
        'if (false)'
  ''
  # The fork's explicit updater otherwise downloads binaries and replaces itself.
  + ''
    substituteInPlace packages/opencode/src/cli/cmd/update.ts \
      --replace-fail 'handler: async () => {' \
        'handler: async () => {
          if (process.env.OPENCODE_DISABLE_AUTOUPDATE) {
            UI.println("Self-update is disabled. Update through your package manager.");
            return;
          }'
  '';

  nativeBuildInputs = [
    bun
    nodejs
    installShellFiles
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
  env.OPENCODE_DISABLE_MODELS_FETCH = true;
  env.OPENCODE_VERSION = finalAttrs.version;
  env.OPENCODE_CHANNEL = "stable";

  buildPhase = ''
    runHook preBuild

    cd ./packages/opencode
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts config.json tui.json
    substituteInPlace config.json \
      --replace-fail "https://models.dev/model-schema.json" \
                     "file://$out/share/model-schema.json"

    runHook postBuild
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    (cd ../tui && bun test test/external-diff-viewer.test.ts)

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/opencode-*/bin/opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
     --prefix PATH : ${
       lib.makeBinPath ([ ripgrep ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sysctl ])
     } \
    --set OPENCODE_DISABLE_AUTOUPDATE true

    ln -s opencode $out/bin/ocv

    install -Dm644 ${models-dev.jsonschema} $out/share/model-schema.json
    install -Dm644 config.json $out/share/config.json
    install -Dm644 tui.json $out/share/tui.json
    install -Dm644 ../web/public/theme.json $out/share/theme.json

    runHook postInstall
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      codesign --force --sign - $out/bin/.opencode-wrapped
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd ocv \
        --bash <($out/bin/ocv completion) \
        --zsh <(SHELL=/bin/zsh $out/bin/ocv completion)
      substitute $out/share/bash-completion/completions/ocv.bash \
        $out/share/bash-completion/completions/opencode.bash \
        --replace-fail ocv opencode
      substitute $out/share/zsh/site-functions/_ocv \
        $out/share/zsh/site-functions/_opencode \
        --replace-fail ocv opencode
    '';

  dontStrip = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [
    "HOME"
    "OPENCODE_DISABLE_MODELS_FETCH"
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    node_modules = node_modules finalAttrs;
    jsonschema = {
      config = "${finalAttrs.finalPackage}/share/config.json";
      theme = "${finalAttrs.finalPackage}/share/theme.json";
      tui = "${finalAttrs.finalPackage}/share/tui.json";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v([0-9]+\\.[0-9]+\\.[0-9]+-ocv\\.[0-9]+\\.[0-9]+)"
        "--subpackage"
        "node_modules"
      ];
    };
    tests.cli =
      runCommand "opencode-vim-cli-test"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            jq
          ];
        }
        ''
          export HOME="$TMPDIR/home"
          mkdir -p "$HOME"
          export OPENCODE_DISABLE_MODELS_FETCH=true
          test "$(ocv --version)" = '${finalAttrs.version}'
          test "$(opencode --version)" = '${finalAttrs.version}'
          ocv --help > help.txt 2>&1
          grep -q 'ocv' help.txt
          ocv completion > completion.txt
          test -s completion.txt
          ocv update > update.txt 2>&1
          grep -q 'Self-update is disabled' update.txt
          jq -e '.properties.diff_viewer.properties.command.type == "array"' \
            ${finalAttrs.passthru.jsonschema.tui} >/dev/null
          jq -e '.properties.vim_initial_mode' \
            ${finalAttrs.passthru.jsonschema.tui} >/dev/null
          jq -e . ${finalAttrs.passthru.jsonschema.config} >/dev/null
          jq -e . ${finalAttrs.passthru.jsonschema.theme} >/dev/null
          test -s ${finalAttrs.finalPackage}/share/bash-completion/completions/ocv.bash
          test -s ${finalAttrs.finalPackage}/share/zsh/site-functions/_ocv
          grep -q 'complete .* ocv' \
            ${finalAttrs.finalPackage}/share/bash-completion/completions/ocv.bash
          grep -q 'complete .* opencode' \
            ${finalAttrs.finalPackage}/share/bash-completion/completions/opencode.bash
          grep -q '#compdef ocv' ${finalAttrs.finalPackage}/share/zsh/site-functions/_ocv
          grep -q '#compdef opencode' ${finalAttrs.finalPackage}/share/zsh/site-functions/_opencode
          touch "$out"
        '';
  };

  meta = {
    description = "Modal, Vim-inspired fork of OpenCode";
    homepage = "https://github.com/leohenon/opencode-vim";
    changelog = "https://github.com/leohenon/opencode-vim/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "ocv";
  };
})
