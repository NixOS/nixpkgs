{ lib, buildGoModule, fetchFromGitLab, pkg-config, icu }:

buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "4.3.8";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    sha256 = "sha256-CePFRk+Dpndv4BtINUn8/Y4fhuO4sCyh4+erjfIHZvI=";
  };

  vendorHash = "sha256-SEYHROFFaR7m7K6l4+zipX0QNYWpbf8qI4pAp1pKAsY=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab.";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio yayayayaka ];
  };
}
