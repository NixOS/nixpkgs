{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
  pkgs,
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
    with pkgs;
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreFoundation
        SystemConfiguration
      ]
    );

  meta = {
    description = "A web-app pentesting suite written in rust";
    homepage = "https://github.com/pwnwriter/kanha";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "kanha";
  };
}
