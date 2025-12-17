{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "18.6.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-orEp/fkLmk0wKC8ceHesqYfA6yIDuxvFKX09MzA5fnU=";
  };

  vendorHash = "sha256-AL6V2LPzCGo/7IuY8msip35OScfocp3zO2ZzM8cZfnU=";
  subPackages = [ "." ];

  ldflags = [
    "-X"
    "main.VERSION=${version}"
  ];

  meta = {
    description = "Daemon used to serve static websites for GitLab users";
    mainProgram = "gitlab-pages";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.gitlab ];
  };
}
