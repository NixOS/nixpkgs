{ stdenv, lib, buildGoModule, fetchFromGitHub }:
let
  pname = "e1s";
  version = "1.0.37";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    rev = "refs/tags/v${version}";
    hash = "sha256-lqaLfGEllyRlVPkUfLUzPO2o+Ruzp1lFD6/RY4o1L14=";
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
