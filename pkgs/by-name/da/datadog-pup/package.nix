{
  lib,
  cacert,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "datadog-pup";
  version = "2.3.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "pup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pk/ak21mY+k0TNoH7SaVVWysdGmhwfSvaNFJFoGSbFU=";
  };

  cargoHash = "sha256-8OEL9r+yKBjfEeaenQ1B14NvLJeq5alnmZIoD1v5e4Y=";

  checkType = "debug";
  dontUseCargoParallelTests = true;
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # These tests fail when stdout is a tty, due to ANSI color codes from comfy-table
    "--skip=output::tests::test_table_links_cover_scalar_vertical_and_horizontal_layouts"
    "--skip=output::tests::test_table_links_emit_normalized_targets"
    "--skip=output::tests::test_table_links_preserve_invisible_separators"
    "--skip=output::tests::test_table_links_reject_user_info_urls"
    "--skip=output::tests::test_table_links_use_full_target_for_truncated_labels"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
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
