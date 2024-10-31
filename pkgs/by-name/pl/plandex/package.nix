{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "plandex";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "plandex-ai";
    repo = "plandex";
    rev = "cli/v${version}";
    hash = "sha256-q3DBkYmZxgrdlEUdGgFCf5IR17lKmYp7U5BD/4GXxjo=";
  };

  sourceRoot = "${src.name}/app/cli";

  vendorHash = "sha256-aFfgXGRnsqS7Ik5geQ6yXL+8X0BfNhHGzF7GKIDC4iE=";

  meta = {
    mainProgram = "plandex";
    description = "AI driven development in your terminal. Designed for large, real-world tasks. The sli part";
    homepage = "https://plandex.ai/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ viraptor ];
  };
}
