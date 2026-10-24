{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-pages";
  version = "19.5.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GIKcKFAuxwEoQXzve2L8snDwo7sIvIq+a4LcNz0bx28=";
  };

  vendorHash = "sha256-oOTts4+u+bGGldUtXofoSqUY1XjLb+TjrsIL5tDNeic=";
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
