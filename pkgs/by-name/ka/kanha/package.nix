{
  lib,
  rustPlatform,
  fetchCrate,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "kanha";
  version = "0.1.2";

  src = fetchCrate {
    inherit version;
    pname = "kanha";
    hash = "sha256-ftTmYCkra3x/oDgGJ2WSf6yLeKXkwLJXhjuBdv7fVLY=";
  };

  cargoHash = "sha256-bO37UYApe1CbwcfG8j/1UPu6DlYqlGPLsh0epxh8x3M=";

  buildInputs = [ openssl ];

  meta = {
    description = "Web-app pentesting suite written in rust";
    homepage = "https://github.com/pwnwriter/kanha";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "kanha";
  };
}
