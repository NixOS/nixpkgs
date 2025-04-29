{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-bO37UYApe1CbwcfG8j/1UPu6DlYqlGPLsh0epxh8x3M=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreFoundation
        SystemConfiguration
      ]
    );

  meta = {
    description = "Web-app pentesting suite written in rust";
    homepage = "https://github.com/pwnwriter/kanha";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "kanha";
  };
}
