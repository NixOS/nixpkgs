{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
  libgit2,
  openssl,
  zstd,
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

  postPatch =
    # Swift propagates the 27.0 SDK, which requires a newer deployment target.
    # SwiftPM uses Swift Build, which uses a different folder hierarchy for its build artifacts and naming convention
    # for compiled object files.
    ''
      substituteInPlace apple-catalog-parsing/build.rs \
        --replace-fail 'apple-macosx10.12' 'apple-macosx${stdenv.hostPlatform.darwinMinVersion}' \
        --replace-fail 'swift-scratch/release' 'swift-scratch/out' \
        --replace-fail 'AssetCatalogParser.build' 'Intermediates.noindex/AssetCatalogParser.build/Release/AssetCatalogParser-t.build/Objects-normal/${stdenv.hostPlatform.swift.arch}' \
        --replace-fail 'ObjcSupport.build' 'Intermediates.noindex/AssetCatalogParser.build/Release/ObjcSupport-t.build/Objects-normal/${stdenv.hostPlatform.swift.arch}' \
        --replace-fail '.m.o' '.o' \
        --replace-fail '.swift.o' '.o'
    ''
    # The version of libgit2-sys used by sentry-cli doesn’t support the version of libgit2 packaged in Nixpkgs,
    # but it works, so use it anyway. This can be dropped once sentry-cli updates its dependencies.
    + ''
      substituteInPlace ../sentry-*-vendor/source-registry-0/libgit2-sys-*/build.rs \
        --replace-fail '"1.7.2".."1.8.0"' '"1.7.2"..="${lib.getVersion libgit2}"'
    '';

  cargoHash = "sha256-CwULTOZN2TTpB8heLuegID38ub6J3XoiY7l7UW1VcGo=";

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

  buildInputs = [
    libgit2
    openssl
    zstd
  ];

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
