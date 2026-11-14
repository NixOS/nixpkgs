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
  wayland,
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
          --filter ./packages/cli \
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

      outputHash = "sha256-zd8lZkZvGAyQQn3SyzxIB9YSLfXDM+tdJVT18KYpORc=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode-vim";
  version = "2.1.4-ocv.4.15";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "leohenon";
    repo = "opencode-vim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gMRoGdzJmGkZiXzeC7eHun/de57hH2xJjAWdx6JuFQo=";
  };

  # Use the packaged Bun version.
  postPatch = ''
    substituteInPlace packages/script/src/index.ts \
      --replace-fail \
      'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
      'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
  ''
  # The fork's explicit updater otherwise downloads binaries and replaces itself.
  + ''
    substituteInPlace packages/cli/src/commands/handlers/upgrade.ts \
      --replace-fail '      intro("Upgrade")' \
        '      if (process.env.OPENCODE_DISABLE_AUTOUPDATE) {
          log.info("Self-update is disabled. Update through your package manager.");
          return;
        }
        intro("Upgrade")'
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
  env.OPENCODE_CHANNEL = "prod";
  env.NODE_OPTIONS = "--max-old-space-size=4096";

  buildPhase = ''
    runHook preBuild

    cd ./packages/cli
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts cli.json
    bun --bun -e '
      import { Schema } from "effect";
      import { Config } from "@opencode/schema/config";
      const doc = Schema.toJsonSchemaDocument(Config.Info, { onExcessProperty: "error" });
      await Bun.write("config.json", JSON.stringify({
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        ...doc.schema,
        "$defs": doc.definitions,
      }));
    '

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

    install -Dm755 dist/cli-*/bin/opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
     --set OPENCODE_DISABLE_AUTOUPDATE true \
     --prefix PATH : ${
       lib.makeBinPath ([ ripgrep ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sysctl ])
     } ${lib.optionalString stdenv.hostPlatform.isLinux ''
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland ]}
     ''}

    ln -s opencode $out/bin/ocv

    install -Dm644 ${models-dev.jsonschema} $out/share/model-schema.json
    install -Dm644 config.json $out/share/config.json
    install -Dm644 cli.json $out/share/cli.json
    install -Dm644 ../web/public/theme.json $out/share/theme.json

    runHook postInstall
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      codesign --force --sign - $out/bin/.opencode-wrapped
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      $out/bin/ocv --completions bash > ocv.bash
      $out/bin/ocv --completions zsh > _ocv
      $out/bin/ocv --completions fish > ocv.fish
      installShellCompletion --cmd ocv \
        --bash ocv.bash \
        --zsh _ocv \
        --fish ocv.fish
      substitute $out/share/bash-completion/completions/ocv.bash \
        $out/share/bash-completion/completions/opencode.bash \
        --replace-fail ocv opencode
      substitute $out/share/zsh/site-functions/_ocv \
        $out/share/zsh/site-functions/_opencode \
        --replace-fail ocv opencode
      substitute $out/share/fish/vendor_completions.d/ocv.fish \
        $out/share/fish/vendor_completions.d/opencode.fish \
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
      cli = "${finalAttrs.finalPackage}/share/cli.json";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version=unstable"
        "--version-regex"
        "v(2\\.[0-9]+\\.[0-9]+-ocv\\.[0-9]+\\.[0-9]+)"
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
          test "$(ocv --version)" = 'ocv v${finalAttrs.version}'
          test "$(opencode --version)" = 'ocv v${finalAttrs.version}'
          ocv --help > help.txt 2>&1
          grep -q 'ocv' help.txt
          ocv --completions bash > completion.txt
          test -s completion.txt
          ocv upgrade > update.txt 2>&1
          grep -q 'Self-update is disabled' update.txt
          jq -e 'any(.properties.diffs.anyOf[] | .properties.command.anyOf[]?; .type == "array")' \
            ${finalAttrs.passthru.jsonschema.cli} >/dev/null
          jq -e '.properties.vim_initial_mode' \
            ${finalAttrs.passthru.jsonschema.cli} >/dev/null
          jq -e 'any(.. | objects; .properties.model and .properties.permissions)' \
            ${finalAttrs.passthru.jsonschema.config} >/dev/null
          jq -e . ${finalAttrs.passthru.jsonschema.theme} >/dev/null
          test -s ${finalAttrs.finalPackage}/share/bash-completion/completions/ocv.bash
          test -s ${finalAttrs.finalPackage}/share/zsh/site-functions/_ocv
          test -s ${finalAttrs.finalPackage}/share/fish/vendor_completions.d/ocv.fish
          grep -q 'complete .* ocv' \
            ${finalAttrs.finalPackage}/share/bash-completion/completions/ocv.bash
          grep -q 'complete .* opencode' \
            ${finalAttrs.finalPackage}/share/bash-completion/completions/opencode.bash
          grep -q '#compdef ocv' ${finalAttrs.finalPackage}/share/zsh/site-functions/_ocv
          grep -q '#compdef opencode' ${finalAttrs.finalPackage}/share/zsh/site-functions/_opencode
          grep -q 'complete -c ocv' ${finalAttrs.finalPackage}/share/fish/vendor_completions.d/ocv.fish
          grep -q 'complete -c opencode' ${finalAttrs.finalPackage}/share/fish/vendor_completions.d/opencode.fish
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
