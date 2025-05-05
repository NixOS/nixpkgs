{
  lib,
  buildGoModule,
  fetchFromGitLab,
  pkg-config,
  icu,
}:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.5.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-b2kXp77pb9MXMRJsbDdNOXub8eZbZkHRwu/Ru0Voi60=";
  };

  vendorHash = "sha256-9T8LbMROLcQYm9cT32Uc6Cuxwt9OYj3WzSYFgSQg1HQ=";

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
