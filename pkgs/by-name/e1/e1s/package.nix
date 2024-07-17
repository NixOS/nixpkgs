{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "e1s";
  version = "1.0.38";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    rev = "refs/tags/v${version}";
    hash = "sha256-OFnriW+rerVTyonuXe9qilR78Qok6QUYQvTDbsTi5L0=";
  };

  vendorHash = "sha256-oQVZ1SNXaXOngZazUVeWLvtZu17XvtIcrx+XC6PvGH0=";

  meta = with lib; {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/derailed/e1s/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "e1s";
    maintainers = with maintainers; [ zelkourban ];
  };
}
