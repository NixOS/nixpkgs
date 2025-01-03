{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
  # darwin dependencies
, darwin
, libiconv
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "cargo-geiger@v${version}";
    hash = "sha256-/5yuayqneZV6aVQ6YFgqNS2XY3W6yETRQ0kE5ovc7p8=";
  };

  cargoPatches = [
    # https://github.com/geiger-rs/cargo-geiger/pull/528
    ./fix-build-with-rust-1.80.patch
  ];

  cargoHash = "sha256-511KeTykHw3xbnsuwIt2QmBK3mG9yK23z0yrS3eIY74=";

  patches = [
    ./allow-warnings.patch
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation Security libiconv curl ]);
  nativeBuildInputs = [ pkg-config ]
    # curl-sys wants to run curl-config on darwin
    ++ lib.optionals stdenv.isDarwin [ curl.dev ];

  # skip tests with networking or other failures
  checkFlags = [
    "--skip serialize_test1_quick_report"
    "--skip serialize_test2_quick_report"
    "--skip serialize_test3_quick_report"
    "--skip serialize_test4_quick_report"
    "--skip serialize_test6_quick_report"
    "--skip serialize_test7_quick_report"
    "--skip serialize_test1_report"
    "--skip serialize_test2_report"
    "--skip serialize_test3_report"
    "--skip serialize_test4_report"
    "--skip serialize_test6_report"
    "--skip serialize_test7_report"
    # multiple test cases that time-out or cause memory leaks
    "--skip test_package"
    "--skip test_package_update_readme::case_2"
    "--skip test_package_update_readme::case_3"
    "--skip test_package_update_readme::case_5"
  ];

  meta = with lib; {
    homepage = "https://github.com/rust-secure-code/cargo-geiger";
    changelog = "https://github.com/rust-secure-code/cargo-geiger/blob/cargo-geiger-${version}/CHANGELOG.md";
    description = "Detects usage of unsafe Rust in a Rust crate and its dependencies";
    mainProgram = "cargo-geiger";
    longDescription = ''
      A cargo plugin that detects the usage of unsafe Rust in a Rust crate and
      its dependencies. It provides information to aid auditing and guide
      dependency selection but it can not help you decide when and why unsafe
      code is appropriate.
    '';
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ evanjs gepbird jk matthiasbeyer ];
  };
}
