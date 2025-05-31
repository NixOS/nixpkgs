{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-appraiser";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "washanhanzi";
    repo = "cargo-appraiser";
    tag = "v${version}";
    hash = "sha256-5n/HN9vrEqQcvTa19KhoF8EvS7HhO9Q3smMUcauI+n4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+Mb1sSxaSoF/LNJo/Myb+ZYgpzhe8ltKMJ41KTlXLuQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = with lib; {
    description = "LSP server for Cargo.toml files";
    mainProgram = "cargo-appraiser";
    homepage = "https://github.com/washanhanzi/cargo-appraiser";
    changelog = "https://github.com/washanhanzi/cargo-appraiser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ timon ];
  };
}
