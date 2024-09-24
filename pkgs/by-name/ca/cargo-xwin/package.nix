{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-Lpcofb4yz1pR6dNJEnpkkCFdYjgt0qMzVP55kgKqjFA=";
  };

  cargoHash = "sha256-xVG1nET020rfMIjhIcCtNr9ZCj8SgQAvXePjyKSPjUs=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
