{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "e1s";
  version = "1.0.41";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    rev = "refs/tags/v${version}";
    hash = "sha256-JYda+CoTa8HAZ0B0kcr4s9u+4dlhthFLpjGaZqAFuhU=";
  };

  vendorHash = "sha256-u6h/sqI0Rqs3ZmVXtMNVuL3h9Cj15+mM+QnIaylzlHI=";

  meta = with lib; {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/keidarcy/e1s/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "e1s";
    maintainers = with maintainers; [ zelkourban ];
  };
}
