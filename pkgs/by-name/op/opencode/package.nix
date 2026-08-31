{
  lib,
  stdenv,
  bun,
  darwin,
  fetchFromGitHub,
  makeWrapper,
  models-dev,
  nodejs,
  nix-update-script,
  ripgrep,
  sysctl,
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

        # opencode targets only Linux and Darwin (see meta.platforms), so the
        # Windows executables that "bun install --os=*" fetches are never
        # executed. Dropping them keeps the output reproducible on hosts whose
        # security endpoint agents scan the store, and removes the vulnerable
        # bundled 7za.exe that will be quarantined.
        find $out -type f -name '*.exe' -delete

        runHook postInstall
      '';

      # NOTE: Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      outputHash = "sha256-dJtPehOvtG5RuzXEhEIXhu15liVcCKTeFwRTElcox4w=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.18.25";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uVW11r2tyGUTzMn1Y+HweD68H7u05UN6EQcXFJbNyS4=";
  };

  postPatch =
    # Relax Bun version check to be a warning instead of an error
    ''
      substituteInPlace packages/script/src/index.ts \
        --replace-fail \
        'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
        'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
    ''
    # Skip smoke test
    + ''
      substituteInPlace packages/opencode/script/build.ts \
        --replace-fail \
        'if (item.os === process.platform && item.arch === process.arch && !item.abi)' \
        'if (false)'
    '';

  nativeBuildInputs = [
    bun
    nodejs
    installShellFiles
    makeWrapper
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

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/opencode-*/bin/opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
     --prefix PATH : ${
       lib.makeBinPath (
         [
           ripgrep
         ]
         ++ lib.optionals stdenv.hostPlatform.isDarwin [
           sysctl
         ]
       )
     } \
    --set OPENCODE_DISABLE_AUTOUPDATE true \
    --run '
      # nixpkgs previously built OpenCode with OPENCODE_CHANNEL=stable. "stable"
      # is no longer an upstream channel, so it caused OpenCode to store its database
      # as opencode-stable.db. After switching to the upstream production channel,
      # OpenCode would normally use opencode.db instead, making existing sessions
      # appear to be lost. Keep using the legacy database until the user migrates
      # it, unless they explicitly configured OPENCODE_DB or disabled this workaround.

      data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
      legacy="$data_home/opencode/opencode-stable.db"
      canonical="$data_home/opencode/opencode.db"

      if [ -z "''${OPENCODE_DB:-}" ] \
        && [ -z "''${NIXPKGS_OPENCODE_DISABLE_LEGACY_DB_WORKAROUND:-}" ] \
        && [ -e "$legacy" ] \
        && [ ! -e "$canonical" ]; then
        export OPENCODE_DB="opencode-stable.db"

        # Only show migration guidance when stderr is attached to a terminal.
        # Non-interactive uses such as `opencode web`, services, or scripts
        # should continue starting normally with the legacy database selected.
        if [ -t 2 ]; then
          echo "Detected legacy nixpkgs OpenCode database at $legacy." >&2
          echo "Continuing to use it for compatibility." >&2
          echo "See https://github.com/NixOS/nixpkgs/pull/558549 for migration instructions." >&2
          echo "Set NIXPKGS_OPENCODE_DISABLE_LEGACY_DB_WORKAROUND=1 to disable this workaround." >&2
        fi
      fi
    '

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
      installShellCompletion --cmd opencode \
        --bash <($out/bin/opencode completion) \
        --zsh <(SHELL=/bin/zsh $out/bin/opencode completion)
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
    jsonschema = {
      config = "${finalAttrs.finalPackage}/share/config.json";
      theme = "${finalAttrs.finalPackage}/share/theme.json";
      tui = "${finalAttrs.finalPackage}/share/tui.json";
    };
    node_modules = node_modules finalAttrs;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    changelog = "https://github.com/anomalyco/opencode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      delafthi
      DuskyElf
      graham33
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "opencode";
  };
})
