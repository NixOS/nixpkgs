{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "jwtinfo";
  version = "0.4.4";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lmammino";
    repo = "jwtinfo";
    rev = "v${version}";
    hash = "sha256-FDN9K7KnMro2BluHB7I0HTDdT9YXxi8UcOoBhKx/5dA=";
  };

  cargoHash = "sha256-iGvwuLiF8yGb4IxBxGH0M79SlNqZ5lpsXTNiVT7VGrU=";

  meta = {
    description = "Command-line tool to get information about JWTs";
    homepage = "https://github.com/lmammino/jwtinfo";
    changelog = "https://github.com/lmammino/jwtinfo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "jwtinfo";
  };
}
