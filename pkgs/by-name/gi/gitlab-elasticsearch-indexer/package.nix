{
  lib,
  buildGoModule,
  fetchFromGitLab,
  pkg-config,
  icu,
}:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.6.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-XerIPK+s0OWYAqKVqE3HSSI+D4cXixYqRHmf9/4C2eg=";
  };

  vendorHash = "sha256-qNGACM5DKufyNVKhJyakmMRbaMXi+JJUfojhWdk0ptU=";

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
