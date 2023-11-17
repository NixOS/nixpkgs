{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.14.9";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-y2hlzewDWYxkKhr77JB3lkYo5hexcdmPiCRbXLtnolM=";
  };

  cargoHash = "sha256-uIFjWgoNCU5kUX4i1Law/YE0TmFLOi6V3Y4b9BpQlI4=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
