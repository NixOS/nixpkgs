{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mchprs";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "MCHPR";
    repo = "MCHPRS";
    rev = "refs/tags/v${version}";
    hash = "sha256-Jm9ZsqCKOIxZsXQbCluYu7MgOD7hXYljcv/URaNVUW0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hematite-nbt-0.5.2" = "sha256-ohhsMlRLFNesccxhqn0GAiVswcdMldD3gv0AXcviHU8=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      openssl
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    mainProgram = "mchprs";
    description = "Multithreaded Minecraft server built for redstone";
    homepage = "https://github.com/MCHPR/MCHPRS";
    license = licenses.mit;
    maintainers = with maintainers; [ gdd ];
  };
}
