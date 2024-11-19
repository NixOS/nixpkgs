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

  useFetchCargoVendor = true;
  cargoHash = "sha256-Y927OgFWdum4bQVMAnkhMyYScRd1CAsHpkPoDV8TZuM=";

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
