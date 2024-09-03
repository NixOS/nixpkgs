{ lib
, fetchFromGitHub
, rustPlatform
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "mdt";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    rev = "v${version}";
    hash = "sha256-3lNipCYhzqeAAUQZ2ajcOakNDlwSwbUUvP8Dtu6gBsI=";
  };

  cargoHash = "sha256-wY/FV0evsz+SZYTL63gReqsy/jfPE39eISs5N7vc3ZU=";

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
