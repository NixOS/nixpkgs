{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-bzyEIBOa0yqjAYjWGw4Fbb8Cv3yCCfJ4vV0q600Rwyk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8V5F0uhuJlc2uJtebQoHJT/qRZPCT2gXjwpRFbzUezk=";

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
