{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  fzf,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  ripgrep,
  testers,
  writableTmpDirAsHomeHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.0.78";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o+rNkij9niggHkA+TtexTbrXLK0I9Ol1Cp9NC/wEuAk=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "opencode-node_modules";
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

      # NOTE: Without `--linker=hoisted` the necessary platform specific packages are not created, i.e. `@parcel/watcher-<os>-<arch>` and `@opentui/core-<os>-<arch>`
      bun install \
        --filter=./packages/opencode \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --linker=hoisted \
        --no-progress \
        --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    # NOTE: Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = (lib.importJSON ./hashes.json).node_modules.${stdenvNoCC.hostPlatform.system};
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    models-dev
  ];

  patches = [
    # NOTE: Skip npm pack commands in build.ts since packages are already in node_modules
    ./skip-npm-pack.patch
  ];

  postPatch = ''
    # don't require a specifc bun version
    substituteInPlace packages/script/src/index.ts \
      --replace-fail "if (process.versions.bun !== expectedBunVersion)" "if (false)"
  '';

  configurePhase = ''
    runHook preConfigure

    cd packages/opencode
    cp -R ${finalAttrs.node_modules}/. .

    chmod -R u+w ./node_modules
    # Make symlinks absolute to avoid issues with bun build
    rm ./node_modules/@opencode-ai/script
    ln -s $(pwd)/../../packages/script ./node_modules/@opencode-ai/script
    rm -f ./node_modules/@opencode-ai/sdk
    ln -s $(pwd)/../../packages/sdk/js ./node_modules/@opencode-ai/sdk
    rm -f ./node_modules/@opencode-ai/plugin
    ln -s $(pwd)/../../packages/plugin ./node_modules/@opencode-ai/plugin

    runHook postConfigure
  '';

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
  env.OPENCODE_VERSION = finalAttrs.version;
  env.OPENCODE_CHANNEL = "stable";

  buildPhase = ''
    runHook preBuild

    bun run ./script/build.ts --single

    runHook postBuild
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/opencode-*/bin/opencode $out/bin/opencode

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/opencode \
      --prefix PATH : ${
        lib.makeBinPath [
          fzf
          ripgrep
        ]
      }
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) opencode --version";
      inherit (finalAttrs) version;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "AI coding agent built for the terminal";
    longDescription = ''
      OpenCode is a terminal-based agent that can build anything.
      It combines a TypeScript/JavaScript core with a Go-based TUI
      to provide an interactive AI coding experience.
    '';
    homepage = "https://github.com/sst/opencode";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "opencode";
    badPlatforms = [
      # Problems with bun >= 1.3.2, see https://github.com/oven-sh/bun/issues/24645
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
