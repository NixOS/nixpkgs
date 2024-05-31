{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "otree";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    rev = "v${version}";
    hash = "sha256-M6xmz7aK+NNZUDN8NJCUEODwotJ9VeY3bsueFpwjjjs=";
  };

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.IOKit;

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    outputHashes = {
      "tui-tree-widget-0.20.0" = "sha256-/uLp63J4FoMT1rMC9cv49JAX3SuPvFWPtvdS8pspsck=";
    };
  };

  doCheck = false; # there are no tests

  meta = {
    description = "Command line tool to view objects (json/yaml/toml) in TUI tree widget";
    homepage = "https://github.com/fioncat/otree";
    changelog = "https://github.com/fioncat/otree/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "otree";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
