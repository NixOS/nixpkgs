{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "16.7.4";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-6OPpfn+nylTUp7rNI8NqipbHmLmaV0ezE1qrQqHcuqw=";
  };

  vendorHash = "sha256-NMky8v0YmN2pSeKJ7G0+DWAZvUx2JlwFbqPHvciYroM=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = teams.helsinki-systems.members ++ teams.gitlab.members;
  };
}
