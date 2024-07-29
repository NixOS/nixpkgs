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
  version = "2024.12-aero";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    rev = "nym-binaries-v${version}";
    hash = "sha256-bUY0ctfE1i0pjqdT/LT43FB9rDO5OKBVaTckm5qxnms=";
  };

  swagger-ui = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
    hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bls12_381-0.8.0" = "sha256-4+X/ZQ5Z+Nax4Ot1JWWvvLxuIUaucHkfnDB2L+Ak7Ro=";
      "cosmos-sdk-proto-0.22.0-pre" = "sha256-nRfcAbjFcvAqool+6heYK8joiU5YaSWITnO6S5MRM1E=";
      "defguard_wireguard_rs-0.4.7" = "sha256-+5m1+XGJ6Fi8v6rgjt0jRmwIruIL+OPP7zq/+166WMw=";
      "indexed_db_futures-0.4.2" = "sha256-vVqrD40CBdSSEtU+kQeuZUfsgpJdl8ks+os0Fct8Ung=";
    };
  };

  env = {
    SWAGGER_UI_DOWNLOAD_URL = "file://${swagger-ui}";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
        CoreServices
      ]
    );

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
    homepage = "https://nymtech.net";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
