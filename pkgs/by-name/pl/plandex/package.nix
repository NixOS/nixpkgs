{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "plandex";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "plandex-ai";
    repo = "plandex";
    rev = "cli/v${version}";
    hash = "sha256-mNNL1K+gNhYDuKpGt3FP/L4JxO/bHyebhABOpFjLLLI=";
  };

  ldflags = [
    "-X plandex-cli/version.Version=${version}"
  ];

  sourceRoot = "${src.name}/app/cli";

  vendorHash = "sha256-0wYlCxg0CPPizdhJ1VfZEEcauy2rJeeTqPiiqsExBu8=";

  meta = {
    mainProgram = "plandex";
    description = "AI driven development in your terminal. Designed for large, real-world tasks. The cli part";
    homepage = "https://plandex.ai/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ viraptor ];
  };
}
