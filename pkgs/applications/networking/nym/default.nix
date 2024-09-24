{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
, CoreServices
, nix-update-script
, rustc
}:

let
  version = "1.1.21";
  hash = "sha256-VM0Pc5qyrsn9wV3mfvrAlCfm/rIf3cednZzFtJCT+no=";
in
rustPlatform.buildRustPackage {
  pname = "nym";
  inherit version;

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    rev = "nym-binaries-v${version}";
    inherit hash;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bls12_381-0.6.0" = "sha256-sIZy+CTASP+uiY10nP/N4WfCLjeqkjiNl/FzO0p5WdI=";
      "cosmos-sdk-proto-0.12.3" = "sha256-ekQ9JA6WaTkvHkBKJbYPzfmx6I7LZnhIPiHsZFAP90w=";
      "rocket_cors-0.5.2" = "sha256-hfk5gKtc94g+VZmm+S6HKvg+E71QVKQTK2E3K2MCvz0=";
      "wasm-timer-0.2.5" = "sha256-od+r3ttFpFhcIh8rPQJQARaQLsbLeEZpCY1h9c4gow8=";
    };
  };

  postPatch = ''
    substituteInPlace contracts/vesting/build.rs \
      --replace 'vergen(config).expect("failed to extract build metadata")' '()'

    substituteInPlace common/bin-common/build.rs \
      --replace 'vergen(config).expect("failed to extract build metadata")' '()'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security CoreServices ];

  checkType = "debug";

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    "--skip=commands::upgrade::upgrade_tests"
    "--skip=allowed_hosts::filter::tests::creating_a_new_host_store"
    "--skip=allowed_hosts::filter::tests::getting_the_domain_root"
    "--skip=allowed_hosts::filter::tests::requests_to_allowed_hosts"
    "--skip=allowed_hosts::filter::tests::requests_to_unknown_hosts"
    "--skip=ping::http::tests::resolve_host_with_valid_hostname_returns_some"
  ];

  env = {
    VERGEN_BUILD_TIMESTAMP = "0";
    VERGEN_BUILD_SEMVER = version;
    VERGEN_GIT_SHA = hash;
    VERGEN_GIT_COMMIT_TIMESTAMP = "0";
    VERGEN_GIT_BRANCH = "master";
    VERGEN_RUSTC_SEMVER = rustc.version;
    VERGEN_RUSTC_CHANNEL = "stable";
    VERGEN_CARGO_PROFILE = "release";
  };

  meta = with lib; {
    description = "Mixnet providing IP-level privacy";
    longDescription = ''
      Nym routes IP packets through other participating nodes to hide their source and destination.
      In contrast with Tor, it prevents timing attacks at the cost of latency.
    '';
    homepage = "https://nymtech.net";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
