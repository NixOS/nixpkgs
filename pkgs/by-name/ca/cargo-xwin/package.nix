{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-6IPkNTwSh5aYQUd0MBmAeQ+iv0owxHwgdQWcjsdoEnA=";
  };

  cargoHash = "sha256-lhlqMaqrmEbv2btOf4awtZfEmMVeHGc1JhCpRRlnr90=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
