{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "17.5.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-fjoby/fTh1wAidyOQSqx7VolxzSB0TQYvltJhYduDSY=";
  };

  vendorHash = "sha256-M2RQPkLWsi9rHXI3lSb9w9nxiklTkV8wpC9VoH0SP6M=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    mainProgram = "gitlab-pages";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = teams.gitlab.members;
  };
}
