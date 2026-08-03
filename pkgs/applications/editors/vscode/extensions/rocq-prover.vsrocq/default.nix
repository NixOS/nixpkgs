{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  replaceVars,
  rocqPackages,
  strip-nondeterminism,
  vscode-utils,
  yarnConfigHook,
}:

let
  inherit (rocqPackages) vsrocq-language-server;

  vsix = stdenv.mkDerivation (finalAttrs: {
    name = "rocq-prover-vsrocq-${finalAttrs.version}.vsix";
    pname = "rocq-prover-vsrocq-vsix";
    # When updating the version here, also update the language server
    # rocqPackages.vsrocq-language-server, whose version the client checks at
    # startup, and re-prefetch each of the yarn caches below.
    version = "2.4.3";

    src = fetchFromGitHub {
      owner = "rocq-prover";
      repo = "vsrocq";
      tag = "v${finalAttrs.version}";
      hash = "sha256-R/fpTiYZ9uvtKQcWD4jwUZPvUrcdvHc/wpoTrdkEQoQ=";
    };

    patches = [
      # Opening a Rocq file with no `vsrocqtop` on the PATH makes the extension
      # offer to download and install the VsRocq language server itself. Teach it
      # to fall back to a language server supplied at build time instead, so that
      # no out-of-band installation is needed.
      (replaceVars ./use-builtin-language-server.patch {
        vsrocqtop = lib.getExe' vsrocq-language-server "vsrocqtop";
      })

      # `vite-plugin-lib-inject-css` depends on `@ast-grep/napi`, whose prebuilt
      # `linux-arm64-gnu` binary references an undefined `static_assert` symbol
      # and so cannot be loaded at all, making the build fail on aarch64-linux.
      # Do the little that the plugin does for this package without it.
      ./avoid-ast-grep-napi.patch
    ];

    sourceRoot = "${finalAttrs.src.name}/client";

    # The three webview UIs and the extension itself are four separate yarn
    # projects, each with its own lockfile, so each needs its own offline cache.
    passthru.yarnOfflineCaches = {
      "." = fetchYarnDeps {
        name = "${finalAttrs.pname}-yarn-deps";
        yarnLock = "${finalAttrs.src}/client/yarn.lock";
        hash = "sha256-XpsAUTu+FTCnVaM/eR00qS5OOraHaQ+X3lO/SCC7TV4=";
      };
      "pp-display" = fetchYarnDeps {
        name = "${finalAttrs.pname}-pp-display-yarn-deps";
        yarnLock = "${finalAttrs.src}/client/pp-display/yarn.lock";
        hash = "sha256-57irlPpDci5iv1vWzJMFSy84TPHR/zVb7qGZeXRtboo=";
      };
      "goal-view-ui" = fetchYarnDeps {
        name = "${finalAttrs.pname}-goal-view-ui-yarn-deps";
        yarnLock = "${finalAttrs.src}/client/goal-view-ui/yarn.lock";
        hash = "sha256-eNzMWsELyvQDMY6rlSu1IT5Jeuv3qbOx/XOEvgv2gjI=";
      };
      "search-ui" = fetchYarnDeps {
        name = "${finalAttrs.pname}-search-ui-yarn-deps";
        yarnLock = "${finalAttrs.src}/client/search-ui/yarn.lock";
        hash = "sha256-sqcbU1wSLOAPTtkBuMXnipFkv4cRxa4leArFpy8zfK4=";
      };
    };

    nativeBuildInputs = [
      nodejs
      strip-nondeterminism
      yarnConfigHook
    ];

    strictDeps = true;

    # `yarnConfigHook` only knows how to populate one project, so run it once per
    # project instead of letting it fire on its own.
    dontYarnInstallDeps = true;

    postConfigure = lib.concatLines (
      lib.mapAttrsToList (dir: cache: ''
        (cd ${lib.escapeShellArg dir} && offlineCache=${cache} yarnConfigHook)
      '') finalAttrs.passthru.yarnOfflineCaches
    );

    buildPhase = ''
      runHook preBuild

      # The two webview UIs depend on `pp-display` through its package entry
      # points rather than its sources, so it has to be built first. This is what
      # the `package` script does, minus the non-production `webpack` run that it
      # inherits from `build:all`.
      for project in pp-display goal-view-ui search-ui; do
        (cd $project && yarn --offline run build)
      done
      node_modules/.bin/webpack --mode production --devtool hidden-source-map

      # `vsce package` refuses to run without a `repository` field unless it is
      # told to go ahead, and would otherwise try to reach the network to prune
      # dependencies that webpack has already bundled.
      node_modules/.bin/vsce package --allow-missing-repository --no-dependencies --out $out
      # `vsce` stamps every zip entry with the current time, so the vsix is not
      # reproducible as it comes out.
      strip-nondeterminism --type zip $out

      runHook postBuild
    '';

    dontInstall = true;
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "rocq-prover-vsrocq";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "rocq-prover";
  vscodeExtName = "vsrocq";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  # The `vsrocqtop` path that `use-builtin-language-server.patch` bakes into the
  # bundle only survives as a registered store reference if the language server is
  # also an input of this derivation: Nix records references to the derivation's
  # own inputs, and the inner vsix derivation cannot register it either because
  # the string is compressed inside the zip where the scanner will not find it.
  buildInputs = [ vsrocq-language-server ];

  passthru.vsix = finalAttrs.src;

  meta = {
    description = "VsRocq is an extension for Visual Studio Code with support for the Rocq Prover";
    changelog = "https://github.com/rocq-prover/vsrocq/blob/v${finalAttrs.version}/client/CHANGELOG.md";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=rocq-prover.vsrocq";
    homepage = "https://github.com/rocq-prover/vsrocq";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Zimmi48 ];
  };
})
