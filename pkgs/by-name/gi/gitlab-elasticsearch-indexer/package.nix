{
  lib,
  buildGoModule,
  fetchFromGitLab,
  pkg-config,
  icu,
}:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.7.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-Qlz8YT6lGUtnMXCrfZZjzmSz0AivzcCVEd/tEKzfoYg=";
  };

  vendorHash = "sha256-C0B9fe/S5TODgVTMGBBD5oGH/DsxAvCB6tBLaRdswCA=";

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
