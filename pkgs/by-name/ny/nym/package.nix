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
  version = "2024.14-crunch-patched";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    tag = "nym-binaries-v${version}";
    hash = "sha256-ze0N+Hg+jVFKaoreCrZUUA3cHGtUZFtxCh5RwTqOdsc=";
  };

  swagger-ui = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
    hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
  };

  cargoHash = "sha256-51QdzV4eYnA+pC1b7TagSF1g+n67IvZw3euJyI3ZRtM=";

  env = {
    SWAGGER_UI_DOWNLOAD_URL = "file://${swagger-ui}";
    OPENSSL_NO_VENDOR = true;
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

  env = {
    VERGEN_BUILD_TIMESTAMP = "0";
    VERGEN_BUILD_SEMVER = version;
    VERGEN_GIT_COMMIT_TIMESTAMP = "0";
    VERGEN_GIT_BRANCH = "master";
    VERGEN_RUSTC_SEMVER = rustc.version;
    VERGEN_RUSTC_CHANNEL = "stable";
    VERGEN_CARGO_PROFILE = "release";
  };

  checkFlags = [
    "--skip=ping::http::tests::resolve_host_with_valid_hostname_returns_some"
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
