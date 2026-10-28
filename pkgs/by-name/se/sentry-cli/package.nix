{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
  openssl,
  pkg-config,
  stdenv,
  swift,
  swiftpm,
  replaceVars,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sentry-cli";
  version = "2.58.2";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    tag = finalAttrs.version;
    hash = "sha256-2dxnAwxIdmeA53PETUyDUgi1T4ZH9faBvPCMdRPUDxw=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (replaceVars ./fix-swift-lib-path.patch { swiftLib = lib.getLib swift; })
  ];

  cargoHash = "sha256-CwULTOZN2TTpB8heLuegID38ub6J3XoiY7l7UW1VcGo=";

  # Needed to get openssl-sys to use pkgconfig.
  env.OPENSSL_NO_VENDOR = 1;

  # By default including `swiftpm` in `nativeBuildInputs` will take over `buildPhase`
  dontUseSwiftpmBuild = true;
  dontUseSwiftpmCheck = true;
  dontUseSwiftpmInstall = true;

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    swift
    swiftpm
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = [
    "--skip=integration::send_metric::command_send_metric"
    "--skip=integration::update::command_update"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Asset catalog parsing is disabled on macOS 27, but these tests require it.
    # Upstream declined to fix this because this CLI is being deprecated:
    # https://github.com/getsentry/sentry-cli/issues/3422
    "--skip=commands::build::upload::tests::test_xcarchive_upload_includes_parsed_assets"
    "--skip=commands::build::upload::tests::test_ipa_upload_includes_parsed_assets"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sentry-cli \
        --bash <($out/bin/sentry-cli completions bash) \
        --fish <($out/bin/sentry-cli completions fish) \
        --zsh <($out/bin/sentry-cli completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://docs.sentry.io/cli/";
    license = lib.licenses.bsd3;
    description = "Command line utility to work with Sentry";
    mainProgram = "sentry-cli";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ rizary ];
  };
})
