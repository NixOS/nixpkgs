{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gh,
  git,
  makeBinaryWrapper,
  nix-update-script,
  nodejs_24,
  stdenv,
  versionCheckHook,
  xdg-utils,

  # Extra language servers or other tools to make available to `diffle` on
  # `PATH`, e.g. `diffle.override { extraRuntimePackages = [ rust-analyzer ]; }`.
  extraRuntimePackages ? [ ],
}:

buildNpmPackage (finalAttrs: {
  pname = "diffle";
  version = "0.1.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moritzwilksch";
    repo = "diffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CcI4EV2dVmZ8szR+IND8aq9UJu3zcje/6I6KTOg7tDk=";
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-IUN/Qf5urqSILfX+fwh/RjU6UZ0+i96/T/xBtx5FaVQ=";

  # `npm pack` would run the `prepack` build script a second time.
  npmPackFlags = [ "--ignore-scripts" ];

  # The suite writes a fake `gh` into a temp directory and runs it through
  # `PATH`. Its `#!/usr/bin/env node` shebang cannot resolve in the build
  # sandbox, so point it at the node running the tests.
  postPatch = ''
    substituteInPlace test/server/prMode.test.ts \
      --replace-fail '#!/usr/bin/env node' '#!${lib.getExe' nodejs_24 "node"}'
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
  ];

  # The test suite builds real repositories with `git` and drives `diffle pr`
  # against a stub `gh` it puts on `PATH` itself.
  nativeCheckInputs = [
    git
  ];

  # `diffle` shells out to `gh` for `diffle pr` and to a browser opener, which is
  # `xdg-open` on Linux and `open` on Darwin, where it ships with the system.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath (
      [ gh ] ++ extraRuntimePackages ++ lib.optional stdenv.hostPlatform.isLinux xdg-utils
    ))
  ];

  doCheck = true;

  # Tests bind a loopback port to exercise the CLI's port handling.
  __darwinAllowLocalNetworking = true;

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  postCheck = ''
    # vitest caches run results under node_modules, which the install hook then
    # copies into $out; removing it keeps the output deterministic.
    rm -rf node_modules/.vite
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local Git diff reviewer in the browser";
    homepage = "https://github.com/moritzwilksch/diffle";
    changelog = "https://github.com/moritzwilksch/diffle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ytausch ];
    mainProgram = "diffle";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
