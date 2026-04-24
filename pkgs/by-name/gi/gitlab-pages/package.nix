{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-pages";
  version = "18.11.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O9YzFUVhqy16sMmViLcJ4LMumyGsvPDehkQCGproSFs=";
  };

  vendorHash = "sha256-PUW4cgAiM1GTtvja894OZ4pe0SWChf5JsL4/fkns2kI=";
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
