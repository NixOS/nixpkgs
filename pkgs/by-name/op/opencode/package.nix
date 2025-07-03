{
  lib,
  stdenvNoCC,
  buildGoModule,
  bun,
  fetchFromGitHub,
  fetchurl,
  nix-update-script,
  testers,
}:

let
  opencode-node-modules-hash = {
    "aarch64-darwin" = "sha256-ZI4wJvBeSejhHjyRsYqpfUvJ959WU01JCW+2HIBs3Cg=";
    "aarch64-linux" = "sha256-g/IyhBxVyU39rh2R9SfmHwBi4oMS12bo60Apbay06v0=";
    "x86_64-darwin" = "sha256-ckWsqrwJEpL1ejrOSp5wTGwQYsDapLH3imNnSOEHQSw=";
    "x86_64-linux" = "sha256-Q3zlrS7kuyKJReuIFqsqG5yfDuwLwBoCm0hUpJo9hSU=";
  };
  bun-target = {
    "aarch64-darwin" = "bun-darwin-arm64";
    "aarch64-linux" = "bun-linux-arm64";
    "x86_64-darwin" = "bun-darwin-x64";
    "x86_64-linux" = "bun-linux-x64";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "0.1.185";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UCYfme9l7F3oBt+3sQE37+PwsmeTbnUFarbqVlb1f0I=";
  };

  tui = buildGoModule {
    pname = "opencode-tui";
    inherit (finalAttrs) version;
    src = "${finalAttrs.src}/packages/tui";

    vendorHash = "sha256-/gDzGBCRapDBpEV9x1pB3QsOX9yua2RFY3i4OAjaIqc=";

    subPackages = [ "cmd/opencode" ];

    env.CGO_ENABLED = 0;

    ldflags = [
      "-s"
      "-w"
      "-X=main.Version=${finalAttrs.version}"
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 $GOPATH/bin/opencode $out/bin/tui

      runHook postInstall
    '';
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "opencode-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    buildPhase = ''

      export HOME=$(mktemp -d)
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install \
        --filter=opencode \
        --force \
        --frozen-lockfile \
        --no-progress
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    # Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = opencode-node-modules-hash.${stdenvNoCC.hostPlatform.system};
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  models-dev-data = fetchurl {
    url = "https://models.dev/api.json";
    sha256 = "sha256-igxQOC+Hz2FnXIW/S4Px9WhRuBhcIQIHO+7U8jHU1TQ=";
  };

  nativeBuildInputs = [ bun ];

  patches = [ ./fix-models-macro.patch ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export MODELS_JSON="$(cat ${finalAttrs.models-dev-data})"
    bun build \
      --define OPENCODE_VERSION="'${finalAttrs.version}'" \
      --compile \
      --minify \
      --target=${bun-target.${stdenvNoCC.hostPlatform.system}} \
      --outfile=opencode \
      ./packages/opencode/src/index.ts \
      ${finalAttrs.tui}/bin/tui

    runHook postBuild
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 opencode $out/bin/opencode

    runHook postInstall
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
        "tui"
        "--subpackage"
        "node_modules"
        "--subpackage"
        "models-dev-data"
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
    maintainers = with lib.maintainers; [
      zestsystem
      delafthi
    ];
    mainProgram = "opencode";
  };
})
