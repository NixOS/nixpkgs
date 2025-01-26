{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "crunchy-cli";
  version = "3.6.7";

  src = fetchFromGitHub {
    owner = "crunchy-labs";
    repo = "crunchy-cli";
    rev = "v${version}";
    hash = "sha256-qBIfDkd4a0m1GNgK4tSq2/dLP8K5Pp4m/M468eHgIAg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "native-tls-0.2.12" = "sha256-YqiX3xj2ionDlDRzkClqkt0E4HY4zt0B6+rGf850ZCk=";
    };
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line downloader for Crunchyroll";
    homepage = "https://github.com/crunchy-labs/crunchy-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "crunchy-cli";
  };
}
