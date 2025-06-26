{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "17.11.5";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-6XqEh4k7taGGHw7WoBFVQjV+79v76GqBAXYw/pZtkBo=";
  };

  vendorHash = "sha256-jCuLRXr7WHGxbXVg2JB1vp9WiNaLgsIJ6GJSS4QrlwY=";
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
