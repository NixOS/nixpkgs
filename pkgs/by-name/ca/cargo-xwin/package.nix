{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-srPXWJAMc5IOLucGg0QNG23aqMABftQTM3PjcbZc8+A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1JJSK7Ss4o/Vk1mxQtNfTLOuA5fwfKpcv5MrsJEuXYU=";

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
