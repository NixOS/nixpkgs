{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  zlib,
  testers,
  cargo-semver-checks,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-semver-checks";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = "cargo-semver-checks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y2tkTPctit5rx6OyohPPVo117sGICg6UEDg7RWFmtMA=";
  };

  cargoHash = "sha256-lP4yXCuJ89NqUBZR6zgGi5B570y+5IaabWyzd9qqa3o=";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  checkFlags = [
    # requires internet access
    "--skip=detects_target_dependencies"
    "--skip=query::tests_lints::feature_missing"
    # platform specific tests
    "--skip=target_feature"
  ];

  preCheck = ''
    # requires internet access
    rm -r test_crates/feature_missing

    patchShebangs scripts/regenerate_test_rustdocs.sh
    scripts/regenerate_test_rustdocs.sh

    substituteInPlace test_outputs/integration_snapshots__bugreport.snap \
      --replace-fail \
        'cargo-semver-checks [VERSION] ([HASH])' \
        'cargo-semver-checks ${finalAttrs.version}'
  '';

  passthru = {
    tests.version = testers.testVersion { package = cargo-semver-checks; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to scan your Rust crate for semver violations";
    mainProgram = "cargo-semver-checks";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      chrjabs
    ];
  };
})
