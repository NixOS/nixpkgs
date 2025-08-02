{
  lib,
  fetchFromGitLab,
  git,
  buildGoModule,
}:
let
  data = lib.importJSON ../data.json;
in
buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "18.2.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "${src.name}/workhorse";

  vendorHash = "sha256-A+hCyi4P0JkBY2NYGWSpMsHjEgD43g9ZlPrxWL9Vx7Q=";
  buildInputs = [ git ];
  ldflags = [ "-X main.Version=${version}" ];
  doCheck = false;
  prodyVendor = true;

  meta = {
    homepage = "http://www.gitlab.com/";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gitlab ];
    license = lib.licenses.mit;
  };
}
