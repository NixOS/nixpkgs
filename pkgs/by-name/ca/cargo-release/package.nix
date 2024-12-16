{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  curl,
  darwin,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.25.10";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "refs/tags/v${version}";
    hash = "sha256-eMPwbcMIjYxM5gJm3HSdwzxN7WYOOtzj/Wf7rwuJfWs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cargo-test-macro-0.1.0" = "sha256-5EHfvuwbI14DBkbLWyXepmn9m4Qn2ah2+9J9FHrSOgU=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  nativeCheckInputs = [
    git
  ];

  # disable vendored-libgit2 and vendored-openssl
  buildNoDefaultFeatures = true;

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    mainProgram = "cargo-release";
    homepage = "https://github.com/crate-ci/cargo-release";
    changelog = "https://github.com/crate-ci/cargo-release/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      gerschtli
    ];
  };
}
