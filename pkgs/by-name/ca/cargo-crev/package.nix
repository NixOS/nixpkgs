{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  perl,
  pkg-config,
  curl,
  libiconv,
  openssl,
  gitMinimal,
  gitSetupHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.26.4";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    tag = "v${version}";
    hash = "sha256-tuOFanGmIRQs0whXINplfHNyKBhJ1QGF+bBVxqGX/yU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CmDTNE0nn2BxB//3vE1ao+xnzA1JBhIQdqcQNWuIKHU=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      curl
    ];

  nativeCheckInputs = [
    gitMinimal
    gitSetupHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Cryptographically verifiable code review system for the cargo (Rust) package manager";
    mainProgram = "cargo-crev";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with lib.licenses; [
      asl20
      mit
      mpl20
    ];
    maintainers = with lib.maintainers; [
      b4dm4n
      matthiasbeyer
    ];
  };
}
