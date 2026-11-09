{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  darwin,
  gitUpdater,
  rustc,
  fetchurl,
}:

rustPlatform.buildRustPackage rec {
  pname = "nym";
  version = "2026.9-venaco";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    tag = "nym-binaries-v${version}";
    hash = "sha256-s3I4yfJfewJpMSqzHXmMFzvsfQAsVNZKzIroatpnfpA=";
  };

  swagger-ui = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
    hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
  };

  cargoHash = "sha256-ifdz+jZK9Hgezx4/Q9bDsOZOFynqE4GEFfIwXISuxp8=";

  env = {
    SWAGGER_UI_DOWNLOAD_URL = "file://${swagger-ui}";
    OPENSSL_NO_VENDOR = true;
    VERGEN_BUILD_TIMESTAMP = "0";
    VERGEN_BUILD_SEMVER = version;
    VERGEN_GIT_COMMIT_TIMESTAMP = "0";
    VERGEN_GIT_BRANCH = "master";
    VERGEN_RUSTC_SEMVER = rustc.version;
    VERGEN_RUSTC_CHANNEL = "stable";
    VERGEN_CARGO_PROFILE = "release";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkType = "debug";

  passthru.updateScript = gitUpdater {
    rev-prefix = "nym-binaries-v";
  };

  checkFlags = [
    "--skip=ping::http::tests::resolve_host_with_valid_hostname_returns_some"
    "--skip=ecash::tests::credential_tests::blind_sign_correct"
    "--skip=ecash::tests::credential_tests::already_issued"
    "--skip=ecash::tests::issued_ticketbooks::issued_ticketbooks_for"
    "--skip=ecash::tests::issued_ticketbooks::issued_ticketbooks_challenge_commitment"
  ];

  meta = {
    description = "Mixnet providing IP-level privacy";
    longDescription = ''
      Nym routes IP packets through other participating nodes to hide their source and destination.
      In contrast with Tor, it prevents timing attacks at the cost of latency.
    '';
    changelog = "https://github.com/nymtech/nym/releases/tag/nym-binaries-v${version}";
    homepage = "https://nymtech.net";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
