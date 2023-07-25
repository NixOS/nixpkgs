{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "16.3.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "sha256-9GLXmxyKS/yGM2aCb3YWUflesqrw1RZQxPrgr5N/rhU=";
  };

  vendorHash = "sha256-Pdb+bWsECe7chgvPKFGXxVAWb+AbGF6khVJSdDsHqKM=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.gitlab.members;
  };
}
