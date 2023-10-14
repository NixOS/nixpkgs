{ lib, buildGoModule, fetchFromGitLab, pkg-config, icu }:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "4.3.9";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    sha256 = "sha256-/jo44MlLWZCSUWFW2rJSqugNYZCXEs5pfj0f6fZs4zg=";
  };

  vendorHash = "sha256-TQ6E5eckZNVL6zzaS9m0izWnQitqfpc4MAEoQOVasnA=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab.";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio yayayayaka ];
  };
}
