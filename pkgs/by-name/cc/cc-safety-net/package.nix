{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
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
        # --cpu="*" and --os="*" fetch every platform's packages, so a single
        # outputHash serves all systems. --ignore-scripts also skips
        # upstream's prepare script, which installs lefthook's git hooks.
        bun install \
          --cpu="*" \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --os="*"

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -R node_modules $out/

        # Windows executables, shipped by the biome and lefthook platform
        # packages that --os="*" pulls in, are never run on the supported
        # platforms and can be quarantined by endpoint security software
        # that scans the store. Drop them.
        find $out -type f -name '*.exe' -delete

        runHook postInstall
      '';

      # Required, otherwise the fixed-output derivation references store paths.
      dontFixup = true;

      outputHash = "sha256-CHYiIWNNu28AOgdypqlqx5apbZKRo2MTHJcujJakWVI=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cc-safety-net";
  version = "2.4.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kenryu42";
    repo = "cc-safety-net";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EhAw23cmIf7R9n8AQC7zayyYe0OGoNudMW+uZaYZWQU=";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    # scripts/build.ts runs tsc for the declaration files, and tsc's shebang
    # is `#!/usr/bin/env node`.
    nodejs
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/node_modules .
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # The repository commits dist/ (upstream CI rebuilds and diffs it on
    # every commit); remove it so the install ships what this build
    # produced. Upstream's build script starts with the same clean.
    rm -rf dist

    # Run the build script directly. Upstream's `bun run build` goes through
    # scripts/project-bun.ts, which downloads its pinned bun release from
    # the network whenever the running bun's version differs.
    bun scripts/build.ts

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # tsc leaves empty directory skeletons behind for the declaration files
    # the build relocates; drop them, so the install equals an npm install
    # of the tarball, whose git-tracked dist cannot carry empty directories.
    find dist -type d -empty -delete

    # dist/{index,api,cli}.js are ESM only through the root package.json's
    # `"type": "module"`, so the two are installed side by side.
    mkdir -p $out/lib/cc-safety-net
    cp -R dist $out/lib/cc-safety-net/dist
    install -Dm644 package.json $out/lib/cc-safety-net/package.json

    # The same two bin names npm installs, both to the CommonJS bin loader.
    for bin in cc-safety-net ccsn; do
      makeBinaryWrapper ${lib.getExe nodejs} $out/bin/$bin \
        --add-flags $out/lib/cc-safety-net/dist/bin/cc-safety-net.js
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    node_modules = node_modules finalAttrs;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "Coding agent hook that blocks destructive commands and secret file access";
    homepage = "https://ccsafetynet.com";
    changelog = "https://github.com/kenryu42/cc-safety-net/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.larry0x ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = bun.meta.platforms;
    mainProgram = "cc-safety-net";
  };
})
