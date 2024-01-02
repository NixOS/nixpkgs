{ lib, buildGoModule, fetchFromGitLab, pkg-config, icu }:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "4.4.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    sha256 = "sha256-Qywf5ACxXqY1iUZCsROTLmWeM8gFcqZvnClRo5DlnjY=";
  };

  vendorHash = "sha256-2dUlztXnr7OH/gQ0Q4jQpuO1MdkOy1O4BNGiY223DAA=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab.";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio yayayayaka ];
  };
}
