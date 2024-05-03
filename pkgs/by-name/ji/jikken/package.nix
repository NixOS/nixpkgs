{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "jikken";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jikkenio";
    repo = "jikken";
    rev = "v${version}";
    hash = "sha256-A6+sezhob7GqAzuJsJGH7ZDLTJhCD+f0t3zx/IMdPsI=";
  };

  cargoHash = "sha256-FxsI2ku52MlSGUph3/ovmn6HIwW+cUwVXuwzcd/1DV4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
    ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A powerful, source control friendly REST API testing toolkit";
    homepage = "https://jikken.io/";
    changelog = "https://github.com/jikkenio/jikken/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "jk";
  };
}
