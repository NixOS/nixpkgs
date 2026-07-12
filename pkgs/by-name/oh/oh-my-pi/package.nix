{
  # oh-my-pi includes Puppeteer for visiting websites that
  # require JavaScript, or if supplying the agent with visual data
  # is desired.
  #
  # However, pulling in an entire web browser's closure by default
  # is undesirable, so we leave it overridable instead.
  withPuppeteer ? false,

  bun,
  cargo,
  cmake,
  opus,
  chromium,
  fetchFromGitHub,
  gh,
  installShellFiles,
  lib,
  lspmux,
  makeWrapper,
  napi-rs-cli_3,
  nix-update-script,
  rustPlatform,
  rustc,
  stdenv,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  pkg-config,
}:
let
  puppeteerArgs = builtins.concatStringsSep " " [
    "--set"
    "PUPPETEER_SKIP_CHROMIUM_DOWNLOAD"
    "'true'"
    "--set"
    "PUPPETEER_EXECUTABLE_PATH"
    "'${lib.getExe chromium}'"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "oh-my-pi";
  version = "17.1.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-swtQxjk2HgzkrxHWMmyXWSBSuD6KGvchI4us1cTLzyQ=";
  };

  patches = [
    # NOTE: See https://github.com/NixOS/nixpkgs/pull/519796 and https://github.com/oven-sh/bun/issues/31023
    ./skip-bun-version-check.patch
  ];

  postPatch = ''
    # Upstream is being "smart" and making sure that `napi` is being run
    # using Bun, but our `napi` is a bash wrapper instead of the raw JS.
    substituteInPlace packages/natives/scripts/build-native.ts \
      --replace-fail '`''${process.execPath} ''${napiBin' '`''${napiBin'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-zkNgYhmIeEOM0/ZZLlHtS3RzyN1qz/kcVNK1NICmvl8=";
  };

  bunDeps = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    __structuredAttrs = true;
    strictDeps = true;

    outputHash = "sha256-+SydgHLC2QJhtPh78EKC7EuM307kXmz+RbAjJmR0Hvk=";
    outputHashMode = "recursive";

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    # `node_modules` contains relative symlinks which are broken
    # in this standalone derivation, but work in the final main derivation,
    # since we're copying the required paths (`python`, `packages`) over as well
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install --frozen-lockfile --no-progress

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/node_modules

      rm -rf ./node_modules/.{cache,bin}
      cp -r ./node_modules $out/lib
      cp package.json $out/lib

      runHook postInstall
    '';
  };

  nativeBuildInputs = [
    bun
    cargo
    installShellFiles
    makeWrapper
    napi-rs-cli_3
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    writableTmpDirAsHomeHook
    cmake
  ];

  buildInputs = [
    opus
  ];

  configurePhase = ''
    runHook preConfigure

    cp -r "$bunDeps/lib/node_modules" ./node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run ci:build:native

    bun --cwd=packages/collab-web run gen:tool-views
    bun --cwd=packages/stats run gen:stats
    bun --cwd=packages/coding-agent run gen:mupdf
    bun --cwd=packages/coding-agent run gen:bundle
    # gen:bundle already calls gen:stats and runs gen:stats:reset on the way out.
    bun --cwd=packages/natives run gen:native

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/oh-my-pi

    # `node_modules` contains workspace symlinks the bundle resolves via parent-
    # dir walk at runtime; the symlinks must point into $out/lib/oh-my-pi/packages.
    cp -r \
      packages \
      node_modules \
      python \
      $out/lib/oh-my-pi/

    mkdir -p $out/bin
    makeWrapper "${lib.getExe bun}" "$out/bin/omp" --add-flags $out/lib/oh-my-pi/packages/coding-agent/dist/cli.js \
      --prefix NODE_PATH : "$out/lib/oh-my-pi/node_modules" ${lib.optionalString withPuppeteer puppeteerArgs} \
      --prefix PATH : "${
        lib.makeBinPath [
          gh
          lspmux
        ]
      }"

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd omp \
      --bash <($out/bin/omp completions bash) \
      --zsh <($out/bin/omp completions zsh) \
      --fish <($out/bin/omp completions fish)
  '';

  env = {
    CI = "1";
    PCRE2_SYS_STATIC = "1";
    PI_NATIVE_VARIANT = "modern";
    # `TARGET_PLATFORM` and `TARGET_ARCH` mirror Bun's `process.platform` /
    # `process.arch` values. `TARGET_VARIANTS = "modern"` is only valid for x86_64;
    # the upstream build rejects it on non-x86_64 builds.
    #
    # Note that these throws should ideally never be reached, since we're also declaring `meta.platforms`.
    TARGET_ARCH =
      if stdenv.hostPlatform.isx86_64 then
        "x64"
      else if stdenv.hostPlatform.isAarch64 then
        "arm64"
      else
        throw "oh-my-pi: unsupported host architecture (${stdenv.hostPlatform.parsed.cpu.name}); oh-my-pi supports x86_64 and aarch64";
    TARGET_PLATFORM =
      if stdenv.hostPlatform.isLinux then
        "linux"
      else if stdenv.hostPlatform.isDarwin then
        "darwin"
      else
        throw "oh-my-pi: unsupported host platform (${stdenv.hostPlatform.parsed.kernel.name}); oh-my-pi supports linux, darwin";
    TARGET_VARIANTS = if stdenv.hostPlatform.isx86_64 then "modern" else "baseline";

    # `crates/pi-natives/src/lib.rs` declares `#![feature(alloc_error_hook)]`,
    # which is nightly-only.
    RUSTC_BOOTSTRAP = 1;
  };

  passthru = {
    inherit (finalAttrs) bunDeps;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "bunDeps"
      ];
    };
  };

  meta = {
    description = "⌥ AI Coding agent for the terminal — hash-anchored edits, optimized tool harness, LSP, Python, browser, subagents, and more";
    homepage = "https://github.com/can1357/oh-my-pi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naxdy ];
    mainProgram = "omp";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
