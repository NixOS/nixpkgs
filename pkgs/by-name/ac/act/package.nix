{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  version = "0.2.67";
in
buildGoModule {
  pname = "act";
  inherit version;

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    rev = "refs/tags/v${version}";
    hash = "sha256-yNa6o35YUP8D8K3kQLHQOG3V9mWGoxNvYgw5UQOqAtc=";
  };

  vendorHash = "sha256-bkOLortxztmzAO/KCbQC4YsZ5iAero1yxblCkDZg8Ds=";

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
