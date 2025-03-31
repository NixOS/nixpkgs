{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-duplicates";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "cargo-duplicates";
    rev = "v${version}";
    hash = "sha256-VGxBmzMtev+lXGhV9pMefpgX6nPlzMaPbXq5LMdIvrE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-F6ZQrK4pKpljIQEei3cvxPPnOSBu9cyoaUzz/aS+yQU=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs =
    [
      curl
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    description = "Cargo subcommand for displaying when different versions of a same dependency are pulled in";
    mainProgram = "cargo-duplicates";
    homepage = "https://github.com/Keruspe/cargo-duplicates";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
