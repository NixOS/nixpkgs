{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, xcbuild
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "crunchy-cli";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "crunchy-labs";
    repo = "crunchy-cli";
    rev = "v${version}";
    hash = "sha256-1iLfPaDFhuTShLKmk2ayljibigNGGMIsw49mKx9bRIU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "native-tls-0.2.11" = "sha256-+NeXsxuThKNOzVLBItKcuTAM/0zR/BzJGMKkuq99gBM=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "A pure Rust written Crunchyroll cli client and downloader";
    homepage = "https://github.com/crunchy-labs/crunchy-cli";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "crunchy-cli";
  };
}

