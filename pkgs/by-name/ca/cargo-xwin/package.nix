{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-RfXX6LZrxQmWtjnMVIpCj9KVn5fnvQRGgEeH+gTR0Vk=";
  };

  cargoHash = "sha256-0N2JLENHG6QUcEtw237Oe/fwdgo87DVJ+Gx6wtpP9BU=";

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
