{ lib, buildGoModule, fetchFromGitLab, pkg-config, icu }:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.4.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-jrUNOxqc/k4a/34nHEatGnBorTlh/EuHnEs/GfFRUcI=";
  };

  vendorHash = "sha256-iL8QowfX0OpU9irUP4MJXhGVim7GU2fTMLgJSTAfh9w=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab";
    mainProgram = "gitlab-elasticsearch-indexer";
    license = licenses.mit;
    maintainers = with maintainers; [ yayayayaka ] ++ teams.cyberus.members;
  };
}
