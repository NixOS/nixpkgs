{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste-cli";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${version}";
    hash = "sha256-NqY3Lp1PNnl8Vf+zJZVrcp+VHe2gZbsoEQKAhpdZzT8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vvK9BTDuNwN4/uZEk9AYBN/Hs6dungKz3RNl/lLm8wU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI tool for rustypaste";
    homepage = "https://github.com/orhun/rustypaste-cli";
    changelog = "https://github.com/orhun/rustypaste-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rpaste";
  };
}
