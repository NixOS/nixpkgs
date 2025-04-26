{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  # testing
  testers,
  cargo-geiger,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "geiger-rs";
    repo = "cargo-geiger";
    tag = "cargo-geiger-${version}";
    hash = "sha256-OW/LOZUCGOIl7jeWnzt4SXTo3gplJx/wbC21S1TdZx0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aDgpEfX0QRkQD6c4ant6uSN18WLHVnZISRr7lyu9IzA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # panics
    "--skip serialize_test2_quick_report"
    "--skip serialize_test3_quick_report"
    "--skip serialize_test6_quick_report"
    "--skip serialize_test2_report"
    "--skip serialize_test3_report"
    "--skip serialize_test6_report"
    # requires networking
    "--skip test_package::case_2"
    "--skip test_package::case_3"
    "--skip test_package::case_6"
    "--skip test_package::case_9"
    # panics, snapshot assertions fails
    "--skip test_package_update_readme::case_2"
    "--skip test_package_update_readme::case_3"
    "--skip test_package_update_readme::case_5"
  ];

  passthru.tests.version = testers.testVersion {
    package = cargo-geiger;
  };

  meta = {
    description = "Detects usage of unsafe Rust in a Rust crate and its dependencies";
    longDescription = ''
      A cargo plugin that detects the usage of unsafe Rust in a Rust crate and
      its dependencies. It provides information to aid auditing and guide
      dependency selection but it can not help you decide when and why unsafe
      code is appropriate.
    '';
    homepage = "https://github.com/geiger-rs/cargo-geiger";
    changelog = "https://github.com/geiger-rs/cargo-geiger/blob/cargo-geiger-${version}/CHANGELOG.md";
    mainProgram = "cargo-geiger";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      evanjs
      gepbird
      jk
      matthiasbeyer
    ];
  };
}
