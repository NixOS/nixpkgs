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
  version = "1.26.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "pup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mOfx8FlsjtW90NstauqQEkJ1i+oTOADJ4Ns+8wfsbuI=";
  };

  cargoHash = "sha256-Owv80DIRsW4L0rvsy+Qv8PI4SBlk245LUYTLOugixYM=";

  checkType = "debug";
  dontUseCargoParallelTests = true;
  __darwinAllowLocalNetworking = true;

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
