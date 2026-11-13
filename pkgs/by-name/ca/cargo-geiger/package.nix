{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  # darwin dependencies
  libiconv,
  curl,
  # testing
  testers,
  cargo-geiger,
  writableTmpDirAsHomeHook,
  libgit2,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-geiger";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "geiger-rs";
    repo = "cargo-geiger";
    tag = "geiger-${finalAttrs.version}";
    hash = "sha256-u2WAwGiiZF0qu97QIlsbUO+zFGAjrSQOtMvPsItEpRk=";
  };

  cargoHash = "sha256-MAa268ey/fufKLzrjW8rJmS6GF4hy5NJVsu3pRAKcac=";

  nativeBuildInputs = [
    pkg-config
  ]
  # curl-sys wants to run curl-config on darwin
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ curl.dev ];

  buildInputs = [
    openssl
    libgit2
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    curl
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # skip tests with networking or other failures
  checkFlags = [
    # panics
    "--skip=serialize_test2_quick_report"
    "--skip=serialize_test3_quick_report"
    "--skip=serialize_test6_quick_report"
    "--skip=serialize_test2_report"
    "--skip=serialize_test3_report"
    "--skip=serialize_test6_report"
    # requires networking
    "--skip=test_package::case_2"
    "--skip=test_package::case_3"
    "--skip=test_package::case_6"
    "--skip=test_package::case_9"
    # panics, snapshot assertions fails
    "--skip=test_package_update_readme::case_2"
    "--skip=test_package_update_readme::case_3"
    "--skip=test_package_update_readme::case_5"
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
    changelog = "https://github.com/geiger-rs/cargo-geiger/blob/cargo-geiger-${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "cargo-geiger";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      evanjs
      gepbird
      jk
      matthiasbeyer
    ];
  };
})
