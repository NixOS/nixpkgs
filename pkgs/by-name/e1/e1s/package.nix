{ lib, buildGoModule, fetchFromGitHub }:
let
  pname = "e1s";
  version = "1.0.39";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    rev = "refs/tags/v${version}";
    hash = "sha256-kfG9Nkt5L2YokTLPzPuIAmjCHlZvr3FqZiYLr8bU+K4=";
  };

  vendorHash = "sha256-u6h/sqI0Rqs3ZmVXtMNVuL3h9Cj15+mM+QnIaylzlHI=";

  meta = with lib; {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/derailed/e1s/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "e1s";
    maintainers = with maintainers; [ zelkourban ];
  };
}
