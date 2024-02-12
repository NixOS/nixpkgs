{ lib, buildGoModule, fetchFromGitLab, pkg-config, icu }:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "4.6.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    sha256 = "sha256-HlT3Uj/DWbyK4xGq7SjKjZ90sww6oMiMDo05mtv6rTA=";
  };

  vendorHash = "sha256-YUH/agSy/shHmHRXlfDtgumbka6BjX5NTxgvlNJS4hQ=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab.";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio yayayayaka ];
  };
}
