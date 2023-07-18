{ lib, buildGoModule, fetchFromGitLab, pkg-config, icu }:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "4.3.6";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    sha256 = "sha256-v+iV/ogPEkU7iWSzZDLkm9PdOY9E87Mo6tyce+4KNoo=";
  };

  vendorHash = "sha256-7LqzuBVYqpPI2thIJu4kQgCZGMlBlKI8L+j7AdUYrgQ=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab.";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio yayayayaka ];
  };
}
