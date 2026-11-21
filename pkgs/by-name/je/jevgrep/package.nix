{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  nodejs_22,
  bash,
  gitMinimal,
  makeWrapper,
  writableTmpDirAsHomeHook,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jevgrep";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dzhng";
    repo = "jevgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jfCduW0CP1rsyKncekIjegmLHlkMlbXqYDFtJkRJ0bI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    bun
    nodejs_22
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.nodeModules}/. .
    chmod -R u+w node_modules apps packages
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun scripts/build-cli.ts

    runHook postBuild
  '';

  # let the mock provider bind localhost for the tests
  __darwinAllowLocalNetworking = true;
  doCheck = true;
  checkPhase = ''
    runHook preCheck

    # this just enables the flag, but does NOT actually launch docker
    # not setting it would (silently) skip the tests
    # and we can do so because nix's sandbox already provides the required isolation
    JEVGREP_TEST_IN_DOCKER=1 bun test packages/core/test test/evaluator.test.ts test/retrieval.test.ts test/retrieval-freshness.test.ts
    node --test packages/core/test-node/provider-protocol.mjs
    node --experimental-strip-types --test test/parser/*.test.ts

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    package="$out/lib/jevgrep"
    mkdir -p "$package/node_modules"
    cp -R apps/cli/dist apps/cli/package.json "$package/"
    # the parsers aren't included in the bundle so include them
    # but just copy only their dependency closure
    cp -RL node_modules/{typescript,pyodide,base-64,ws} "$package/node_modules/"
    # skill installer launches npx, which needs a shell and git to fetch skills
    makeWrapper ${lib.getExe nodejs_22} "$out/bin/jg" \
      --add-flags "$package/dist/bin/index.js" \
      --suffix PATH : ${
        lib.makeBinPath [
          nodejs_22
          bash
          gitMinimal
        ]
      }

    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    export JEVGREP_INSTALLED_BINARY="$out/bin/jg"
    export JEVGREP_INSTALLED_PACKAGE="$out/lib/jevgrep"
    export JEVGREP_EXPECTED_SKILL="$PWD/skills/jevgrep/SKILL.md"
    export JEVGREP_TEST_PATH="${lib.makeBinPath [ nodejs_22 ]}"
    node --test --test-reporter=tap --test-concurrency=1 \
      --test-name-pattern='^(installed local commands|actual installed search parses Python)' \
      test/installed.test.mjs > installed-tests.tap 2>&1 || {
        cat installed-tests.tap
        exit 1
      }
    cat installed-tests.tap
    # Check that both tests above actually ran and passed
    # fail unless the report says "# pass 2"
    grep -q '^# pass 2$' installed-tests.tap

    runHook postInstallCheck
  '';

  passthru = {
    nodeModules = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node-modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;
      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];
      dontConfigure = true;
      dontFixup = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR="$TMPDIR/bun-cache"
        bun install --frozen-lockfile --ignore-scripts --no-progress \
          --linker=hoisted --os='*' --cpu='*'

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out"
        find . -type d -name node_modules -prune -exec cp -R --parents '{}' "$out" \;

        runHook postInstall
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-cQmcaLg7SGEonMeQuYZ9AGMKHeoZaOavoUbZe3h1kac=";
    };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "nodeModules"
      ];
    };
  };

  meta = {
    description = "Content-aware source retrieval for coding agents";
    homepage = "https://github.com/dzhng/jevgrep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "jg";
    platforms = bun.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # Pyodide's webassenbly runtime is prebuilt upstream
    ];
  };
})
