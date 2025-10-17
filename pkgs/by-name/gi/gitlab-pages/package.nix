{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "18.4.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-21VCBUE6wGU7DT98YYPuEz7lw6EMqCfe14mofbai0lk=";
  };

  vendorHash = "sha256-FdmozSo/eWTnAxrO+/TZOKataLwDkKfwGOXymkRBVCI=";
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
