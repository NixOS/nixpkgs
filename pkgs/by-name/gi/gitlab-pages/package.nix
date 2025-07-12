{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "18.1.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-XY/WK19nujQPdsicGDHS5gEZf3uJZdW41R4xK9hDML0=";
  };

  vendorHash = "sha256-6ZHKwPhC3N813kiw1NnPOMVc2CBSIClwc4MunDi0gCk=";
  subPackages = [ "." ];

  meta = {
    description = "Daemon used to serve static websites for GitLab users";
    mainProgram = "gitlab-pages";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.gitlab ];
  };
}
