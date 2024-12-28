{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  zlib,
  stdenv,
  darwin,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IcKjiKFvkFvu8+LFCAmm39AGUaUdK8zhtNzzSb8VPE0=";
  };

  cargoHash = "sha256-QfJ7QnGKmbrGDwYtVyAJNNGoAukD97/tmCwAROvWBIg=";

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

  meta = with lib; {
    description = "Tool to scan your Rust crate for semver violations";
    mainProgram = "cargo-semver-checks";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v${version}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
