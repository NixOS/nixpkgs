{
  lib,
  stdenv,
  stdenvNoCC,
  buildGoModule,
  bun,
  fetchFromGitHub,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  testers,
  writableTmpDirAsHomeHook,
}:

let
  bun-target = {
    "aarch64-darwin" = "bun-darwin-arm64";
    "aarch64-linux" = "bun-linux-arm64";
    "x86_64-darwin" = "bun-darwin-x64";
    "x86_64-linux" = "bun-linux-x64";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "0.14.7";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Sf74H2ptZoKkOyqy3JU71B2r2DBdosChiWA0dNpiV0=";
  };

  tui = buildGoModule {
    pname = "opencode-tui";
    inherit (finalAttrs) version src;

    modRoot = "packages/tui";

    vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";

    subPackages = [ "cmd/opencode" ];

    env.CGO_ENABLED = 0;

    ldflags = [
      "-s"
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

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

       export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

       # Disable post-install scripts to avoid shebang issues
       bun install \
         --filter=opencode \
         --force \
         --ignore-scripts \
         --no-progress
         # Remove `--frozen-lockfile` and `--production` — they erroneously report the lockfile needs updating even though `bun install` does not change it.
         # Related to  https://github.com/oven-sh/bun/issues/19088
         # --frozen-lockfile \
         # --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    # Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash =
      {
        x86_64-linux = "sha256-j6p52NXqKsOiySJO83r3qUvxLs1yt8dPG8q5ClOPLA8=";
        aarch64-linux = "sha256-gxAwc34PIN1ErVchyoX7Fv/VhPHzxVOC/F6P8hSeO/w=";
        x86_64-darwin = "sha256-0I6nTjc7gChk2Djv4hFfKMp0wM3ZX57/pCsPVHSDPqk=";
        aarch64-darwin = "sha256-a/WWhsOP4pZfj5+Vlsyt/adaTTgMt2SlH3UOA+sXNgA=";
      }
      .${stdenv.hostPlatform.system};
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    models-dev
  ];

  patches = [
    # Patch `packages/opencode/src/provider/models-macro.ts` to get contents of
    # `_api.json` from the file bundled with `bun build`.
    ./local-models-dev.patch
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .

    runHook postConfigure
  '';

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";

  buildPhase = ''
    runHook preBuild

    bun build \
      --define OPENCODE_TUI_PATH="'${finalAttrs.tui}/bin/tui'" \
      --define OPENCODE_VERSION="'${finalAttrs.version}'" \
      --compile \
      --target=${bun-target.${stdenvNoCC.hostPlatform.system}} \
      --outfile=opencode \
      ./packages/opencode/src/index.ts \

    runHook postBuild
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 opencode $out/bin/opencode

    runHook postInstall
  '';

  # Execution of commands using bash-tool fail on linux with
  # Error [ERR_DLOPEN_FAILED]: libstdc++.so.6: cannot open shared object file: No such
  # file or directory
  # Thus, we add libstdc++.so.6 manually to LD_LIBRARY_PATH
  postFixup = ''
    wrapProgram $out/bin/opencode \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
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
