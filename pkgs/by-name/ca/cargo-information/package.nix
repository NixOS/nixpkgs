{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  rustc,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-information";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hi-rustin";
    repo = "cargo-information";
    rev = "v${version}";
    hash = "sha256-5F8O8M8cz7sdXtqGYuDIeTolovZjx2BLEBCZuBIb9YA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cargo-test-macro-0.1.0" = "sha256-4u3Ium+WYBdyocuehDulRgUOR74JC6AUI2+A5xlnUGw=";
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

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  postFixup = ''
    wrapProgram $out/bin/cargo-info \
      --prefix PATH : ${lib.makeBinPath [ rustc ]}
  '';

  meta = with lib; {
    description = "A cargo subcommand to show information about crates";
    mainProgram = "cargo-info";
    homepage = "https://github.com/hi-rustin/cargo-information";
    changelog = "https://github.com/hi-rustin/cargo-information/blob/v${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ eopb ];
  };
}
