{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "16.3.3";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-TPXMXuxckALObfEcIguJbGToIGp8b2bpd974epaXpyk=";
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
