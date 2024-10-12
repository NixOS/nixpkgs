{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, pkg-config
, openssl
, curl
, rustc
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-information";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hi-rustin";
    repo = "cargo-information";
    rev = "v${version}";
    hash = "sha256-gu1t0jMBJ+mJIVMGy1JlabzcOT4lbmTvO/VQfxLLsWM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cargo-test-macro-0.2.1" = "sha256-3sergm2T4VXT41ERCLL7p9+pJwIKzT54qdla8V58Psk=";
    };
  };

  checkFlags = [
    # Require network access
    "--skip=cargo_information::specify_version_within_ws_and_match_with_lockfile::case"
    "--skip=cargo_information::within_ws::case"
    "--skip=cargo_information::within_ws_with_alternative_registry::case"
    "--skip=cargo_information::within_ws_without_lockfile::case"
    "--skip=cargo_information::transitive_dependency_within_ws::case"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    curl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postFixup = ''
    wrapProgram $out/bin/cargo-info \
      --prefix PATH : ${lib.makeBinPath [ rustc ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand to show information about crates";
    mainProgram = "cargo-info";
    homepage = "https://github.com/hi-rustin/cargo-information";
    changelog = "https://github.com/hi-rustin/cargo-information/blob/v${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ eopb ];
  };
}
