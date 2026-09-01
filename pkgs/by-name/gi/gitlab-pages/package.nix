{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-pages";
  version = "19.3.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4SNECjrdXv/tE6BckPGCJbTdImiJ7p4ukzTppbt1PNA=";
  };

  vendorHash = "sha256-81Q5xtkQhJS9TQYTgXA4yi7zny6yFPTVAOHETOCyHNE=";
  subPackages = [ "." ];

  ldflags = [
    "-X"
    "main.VERSION=${finalAttrs.version}"
  ];

  meta = {
    description = "Daemon used to serve static websites for GitLab users";
    mainProgram = "gitlab-pages";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.gitlab ];
  };
})
