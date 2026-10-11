{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
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
  version = "0.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moritzwilksch";
    repo = "diffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UZ3g94j/+lg1+WMLpC1q9phmAXjJJ71y6CkYrgzSE10=";
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-nWXccU0jC3sgBLfZudQy64VXvPEAUNKfE3XhgxoFABw=";

  # `npm pack` would run the `prepack` build script a second time.
  npmPackFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
  ];

  # The test suite builds real repositories with `git`.
  nativeCheckInputs = [
    git
  ];

  # `diffle` opens the browser with `xdg-open` on Linux and `open` on Darwin,
  # where it ships with the system.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath (extraRuntimePackages ++ lib.optional stdenv.hostPlatform.isLinux xdg-utils))
  ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  postCheck = ''
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
