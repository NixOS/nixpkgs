{ lib
, fetchFromGitHub
, rustPlatform
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "mdt";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    rev = "v${version}";
    hash = "sha256-AwJvB1xLsJCr+r0RJi8jH50QlPq7mbUibvmvYZJi9XE=";
  };

  cargoHash = "sha256-VNuC0tSlFKlQV1KJKxKUiBHEpdVAyQpAJKbYZ8ntVaQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreServices ];

  meta = {
    description = "Markdown renderer in the terminal";
    homepage = "https://github.com/henriklovhaug/md-tui";
    changelog = "https://github.com/henriklovhaug/md-tui/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "mdt";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
