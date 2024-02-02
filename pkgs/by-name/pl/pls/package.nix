{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "pls";
  version = "0.0.1-beta.4";

  src = fetchFromGitHub {
    owner = "dhruvkb";
    repo = "pls";
    rev = "v${version}";
    hash = "sha256-YndQx7FImtbAfcbOpIGOdHQA1V7mbQiYBbpik2I+FCE=";
  };

  cargoHash = "sha256-HzkN856GHhY2sQ0jmQCCQva/yB4zzh+ccrQvibLFhxQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    changelog = "https://github.com/pls-rs/pls/releases/tag/${src.rev}";
    description = "Prettier and powerful ls";
    homepage = "http://pls.cli.rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pls";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
