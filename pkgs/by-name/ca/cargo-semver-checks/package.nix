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

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = "cargo-semver-checks";
    tag = "v${version}";
    hash = "sha256-NPxb2fS5EuymUP0h0HGZ++goOeGwATlpQeRzAPbnF94=";
  };

  cargoHash = "sha256-ACTrtJ/iwCFZf8kH2Sdxx1B8ZKDIiu6elAGJOYbxqs0=";

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
  ];

  preCheck = ''
    # requires internet access
    rm -r test_crates/feature_missing

    patchShebangs scripts/regenerate_test_rustdocs.sh
    scripts/regenerate_test_rustdocs.sh

    substituteInPlace test_outputs/integration_snapshots__bugreport.snap \
      --replace-fail \
        'cargo-semver-checks [VERSION] ([HASH])' \
        'cargo-semver-checks ${version}'
  '';

  passthru = {
    tests.version = testers.testVersion { package = cargo-semver-checks; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to scan your Rust crate for semver violations";
    mainProgram = "cargo-semver-checks";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v${version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
