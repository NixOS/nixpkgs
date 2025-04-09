{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ferron";
  version = "1.0.0-beta11";

  src = fetchFromGitHub {
    owner = "ferronweb";
    repo = "ferron";
    rev = version;
    hash = "sha256-BicCU4LFEUCmlig4vZQ5cYy7Mh9qsS79xiGy0spHOMY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cache_control-0.2.0" = "sha256-Xw8JMo5bCgLfOsjsdyOxl956ggjWqywoQZA8Liz7bKE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "A fast, memory-safe web server written in Rust";
    homepage = "https://github.com/ferronweb/ferron";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "ferron";
  };
}
