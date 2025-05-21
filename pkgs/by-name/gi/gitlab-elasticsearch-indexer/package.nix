{
  lib,
  buildGoModule,
  fetchFromGitLab,
  pkg-config,
  icu,
}:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.5.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-N2H9jLpsP39nKrokWwphAspQwXcL3stAdvNVItIHFyo=";
  };

  vendorHash = "sha256-Go02W09799Vu9v7y+P7z1gj7ijG3No5AVprRrmspPZE=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab";
    mainProgram = "gitlab-elasticsearch-indexer";
    license = licenses.mit;
    maintainers = with maintainers; [ yayayayaka ];
    teams = [ teams.cyberus ];
  };
}
