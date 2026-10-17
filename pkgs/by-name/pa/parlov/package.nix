{
  lib,
  cacert,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "parlov";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gnufood";
    repo = "parlov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NExg4gOnYLNk34LBa5bFwxOAYIC2d86knoAlCqxdMrQ=";
  };

  cargoHash = "sha256-gNejVgmWb6whiyWU49scwE3zWS1dljBFz8c6UicUwY4=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    export SSL_CERT_DIR=${cacert}/etc/ssl/certs
    export CLICOLOR=0
    export TERM=dumb
    export NO_COLOR=1
  '';

  doInstallCheck = true;

  checkFlags = [
    # Skip tests that require network access
    "--skip=scan::tests::pipeline::run_plan_specs_returns_exchanges_on_empty_plan"
    "--skip=scan::tests::verdict::first_threshold_crossed_by_stays_none_when_not_exhaustive"
    "--skip=scan::tests::verdict::stop_decision_none_when_exhaustive"
    # Snapshot is unstable due to terminal coloring differences
    "--skip=snap_"
    "--skip=snapshot_"
    "--skip=snap_delete_405_vs_404_table"
    "--skip=snap_head_204_vs_404_table"
    "--skip=snap_patch_422_vs_404_table"
    "--skip=snapshot_table_"
    "--skip=emg_body_diff_only_table"
    "--skip=emg_status_plus_body_table"
  ];

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool to detect HTTP oracle vulnerabilities through differential probing of RFC-compliant servers";
    homepage = "https://github.com/gnufood/parlov";
    changelog = "https://github.com/gnufood/parlov/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "parlov";
  };
})
