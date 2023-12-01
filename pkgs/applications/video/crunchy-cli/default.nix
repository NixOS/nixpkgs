{ lib
, stdenv
, clangStdenv
, darwin
, xcbuild
, openssl
, pkg-config
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "crunchy-cli";
  version = "3.0.0-dev.10";

  src = fetchFromGitHub {
    owner = "crunchy-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uc19SmVfa5BZYDidlEgV6GNvcm9Dj0mSjdwHP5S+O4A=";
  };

  cargoHash = "sha256-H3D55qMUAF6t45mRbGZl+DORAl1H1a7AOe+lQP0WUUQ=";

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

  meta = with lib; {
    description = "A pure Rust written Crunchyroll cli client and downloader";
    homepage = "https://github.com/crunchy-labs/crunchy-cli";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ stepbrobd ];
    mainProgram = "crunchy-cli";
  };
}

