{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-ci-linter";
  version = "2.4.0";

  src = fetchFromGitLab {
    owner = "orobardet";
    repo = "gitlab-ci-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zH7eeAJzazDf4LnfBxFKMIPIB4Gx4rn7DCEqBV5zIWo=";
  };

  vendorHash = "sha256-GKv7uWnY9UqDuzj/VcXTAjGJUyUEsZws3ORnPCX8mwU=";

  # Build flags based on the project's Makefile
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];
  env.CGO_ENABLED = 0;

  meta = {
    description = ".gitlab-ci.yml lint helper tool";
    homepage = "https://gitlab.com/orobardet/gitlab-ci-linter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "gitlab-ci-linter";
  };
})
