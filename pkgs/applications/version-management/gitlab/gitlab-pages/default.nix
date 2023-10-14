{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "16.4.1";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-aUpuzgFbxMJwKjTn+QAudOeMBSLtLTjaTmwe25f6qxg=";
  };

  vendorHash = "sha256-ko0ycT8HlqVfXf7tck0xcs6rDJMpHxjSoI59gTLgqDQ=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.gitlab.members;
  };
}
