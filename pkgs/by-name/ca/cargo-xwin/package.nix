{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-uu3fKq6ZebDbTBpp5UaAOCWnaeJ0xRgVO+GNDHheKGA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/u1qBe+eOAXqjgly62eFIglO3XuZd/f2w7DcHsqvZGA=";

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
