{ stdenv, lib, buildGoModule, fetchFromGitHub }:
let
  pname = "e1s";
  version = "1.0.36";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    rev = "refs/tags/v${version}";
    hash = "sha256-i2XCys/fXNS7aXxpAPVqFpuQGempcsBEbVuphXPpBIc=";
  };

  vendorHash = "sha256-fTrKqhfUg+/4xid9YWkTNkXm3HGaoeeJU0RIMW2mtq8=";

  meta = with lib; {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/derailed/e1s/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "e1s";
    maintainers = with maintainers; [ zelkourban ];
  };
}
