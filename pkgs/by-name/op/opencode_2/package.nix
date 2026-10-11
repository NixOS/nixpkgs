{
  lib,
  stdenv,
  bun,
  darwin,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  nix-update-script,
  ripgrep,
  sysctl,
  wayland,
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

        # opencode targets only Linux and Darwin (see meta.platforms), so the
        # Windows executables that "bun install --os=*" fetches are never executed.
        find $out -type f -name '*.exe' -delete

        runHook postInstall
      '';

      # NOTE: Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      outputHash = "sha256-wR7VMRcHOcj3hdGdtMoHAgbwNsLsNscHNaCUwKjwr4o=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "2.0.26";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-umhEz5um90EiBHvVZzQw+HoBFO088ZI1g7Ost9BUxhM=";
  };

  postPatch =
    # Relax Bun version check to be a warning instead of an error
    ''
      substituteInPlace packages/script/src/index.ts \
        --replace-fail \
          'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
          'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
    '';

  node_modules = node_modules finalAttrs;

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

    cp -R "$node_modules"/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  env = {
    OPENCODE_DISABLE_MODELS_FETCH = true;
    OPENCODE_VERSION = finalAttrs.version;
    OPENCODE_CHANNEL = "prod";
    NODE_OPTIONS = "--max-old-space-size=4096";
  };

  buildPhase = ''
    runHook preBuild

    cd ./packages/cli
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts config.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/cli-*/bin/opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
      --set OPENCODE_DISABLE_AUTOUPDATE true \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            ripgrep
          ]
          # bun runs sysctl to detect if running on rosetta2
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            sysctl
          ]
        )
      } ${
        # OpenTUI dlopens Wayland for clipboard images
        lib.optionalString stdenv.hostPlatform.isLinux ''
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland ]}
        ''
      }

    # Upstream ships `opencode2` as an alias of `opencode`
    ln -s opencode $out/bin/opencode2

    install -Dm644 config.json $out/share/config.json

    runHook postInstall
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      codesign --force --sign - $out/bin/.opencode-wrapped
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        $out/bin/opencode --completions $shell > opencode.$shell
        substitute opencode.$shell opencode2.$shell --replace-fail opencode opencode2
      done

      installShellCompletion --cmd opencode \
        --bash opencode.bash \
        --fish opencode.fish \
        --zsh opencode.zsh

      installShellCompletion --cmd opencode2 \
        --bash opencode2.bash \
        --fish opencode2.fish \
        --zsh opencode2.zsh
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

  passthru = {
    jsonschema = {
      config = "${finalAttrs.finalPackage}/share/config.json";
    };
    node_modules = node_modules finalAttrs;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
        "--version-regex"
        "^v(2\\..*)$"
      ];
    };
  };

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    changelog = "https://github.com/anomalyco/opencode/releases/tag/${finalAttrs.src.tag}";
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
