{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  zlib,
  stdenv,
  darwin,
  testers,
  cargo-semver-checks,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ZP0Zu9NLhJNsVwKiAj5RuGdZn5Q3meJW7/U+quAdoxw=";
  };

  cargoHash = "sha256-uBRlGz+iQLR/KkvVOOIGmfDy9mr2E4ntsNfTwnxPqyk=";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
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
