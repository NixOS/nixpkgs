{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "jwtinfo";
  version = "0.6.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lmammino";
    repo = "jwtinfo";
    rev = "v${version}";
    hash = "sha256-d88RL3Ii2/akIyxmKMEBqILRuaSP2v/RZ5zuWrwyYkc=";
  };

  cargoHash = "sha256-5lSGVr5iMk4Zai2HNTSXOeJXyXPRAWNEyJeZxMrAMUg=";

  meta = {
    description = "Command-line tool to get information about JWTs";
    homepage = "https://github.com/lmammino/jwtinfo";
    changelog = "https://github.com/lmammino/jwtinfo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "jwtinfo";
  };
}
