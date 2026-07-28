{
  lib,
  cacert,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "datadog-pup";
  version = "1.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "pup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8leLUaoce3i4i2asd0tzhbM4mXAOkn/rdNIaGLLCfko=";
  };

  cargoHash = "sha256-+F5P2tOLGSjABD4B0MG84x1uVI4o06Kl1nZfOS7tP1Y=";

  checkType = "debug";
  dontUseCargoParallelTests = true;
  __darwinAllowLocalNetworking = true;

  checkFlags = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # This test is missing a case for aarch64-linux
    "--skip=extensions::install::tests::test_find_platform_asset_found"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Datadog's observability platform";
    homepage = "https://github.com/DataDog/pup";
    changelog = "https://github.com/DataDog/pup/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "pup";
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.unix;
  };
})
