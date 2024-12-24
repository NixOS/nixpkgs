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

  cargoHash = "sha256-kjHLc+qWo5dB4qbdlIWzk/pjpghRaDcX/7kkjEM219c=";

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
