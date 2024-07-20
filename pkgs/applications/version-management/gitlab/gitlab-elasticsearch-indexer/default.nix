{ lib, buildGoModule, fetchFromGitLab, pkg-config, icu }:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.0.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-856lRCW4+FIiXjOzMkfoYws6SMIKXWVtvr+867QEjCk=";
  };

  vendorHash = "sha256-2XdbTqNGt97jQUJmE06D6M/VxF9+vJAwMM/fF8MP2oo=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab";
    mainProgram = "gitlab-elasticsearch-indexer";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio yayayayaka ];
  };
}
