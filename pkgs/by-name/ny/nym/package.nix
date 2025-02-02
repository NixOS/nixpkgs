{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  darwin,
  nix-update-script,
  rustc,
  fetchurl,
}:

rustPlatform.buildRustPackage rec {
  pname = "nym";
  version = "2024.13-magura-patched";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    tag = "nym-binaries-v${version}";
    hash = "sha256-N9nnDtTIvKJX1wpiAEJ2X7Dv5Qc5V6CiTR/TjJAnv3s=";
  };

  swagger-ui = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
    hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
  };

  cargoHash = "sha256-tkP65GG1E5356lePLVrZdPqx/b9k1lgJ1LoxCgQf08k=";
  useFetchCargoVendor = true;

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

  passthru.updateScript = nix-update-script { };

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
