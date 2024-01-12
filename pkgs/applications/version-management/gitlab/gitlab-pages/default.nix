{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "16.7.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-rUSZDsQt6faNES3ibzo7fJqpzEmXRbbTXOkhOn7jggA=";
  };

  vendorHash = "sha256-NMky8v0YmN2pSeKJ7G0+DWAZvUx2JlwFbqPHvciYroM=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.gitlab.members;
  };
}
