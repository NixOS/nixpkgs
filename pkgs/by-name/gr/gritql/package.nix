{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  zstd,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "gritql";
  version = "0.1.0-alpha.1743007075";

  src = fetchFromGitHub {
    owner = "getgrit";
    repo = "gritql";
    rev = "v${version}";
    hash = "sha256-ru8XnXiwwrlrGFtj8kIXUGBS6jnazLIQklZotTPItSw=";
    fetchSubmodules = true;
  };

  patches = [
    # cargo.toml lists two dependencies with required=false and default-features=false -- an illegal combination
    ./grit-tracing.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-tvwxoqPpVoR7oZJuVfssrwica2dVVs2DyvD9mzW+NwU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Query language for searching, linting, and modifying code";
    homepage = "https://github.com/getgrit/gritql";
    changelog = "https://github.com/getgrit/gritql/releases/tag/v0${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
    mainProgram = "grit";
  };
}
