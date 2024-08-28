{ lib
, fetchFromGitHub
, rustPlatform
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "mdt";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    rev = "v${version}";
    hash = "sha256-HUrL/+uXQ3753Qb5FZkftGZO+u+MsocFO3L3OzarEhg=";
  };

  cargoHash = "sha256-O25cb4aNQiU4T2SzxgzjFqL+pCzbM0d+DkkZHvCkMv8=";

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
