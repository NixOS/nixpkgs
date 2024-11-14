{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  version = "0.2.68";
in
buildGoModule {
  pname = "act";
  inherit version;

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    rev = "refs/tags/v${version}";
    hash = "sha256-BON29uUruBoeBLoBdOgnonrVIyLZlvBW5UyWfxFgjPs=";
  };

  vendorHash = "sha256-yxuOORShJL9nFIS5srZFI31Nyz7xFxnJCmcN8UFhyr0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      kashw2
    ];
  };
}
