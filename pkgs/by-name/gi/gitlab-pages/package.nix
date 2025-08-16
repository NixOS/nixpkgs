{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "18.2.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-z1Pl3xeaoqeF/9qOVcuCpuciu1r6NQ4UhlLe9gy9+nE=";
  };

  vendorHash = "sha256-OubXCpvGtGqegQmdb6R1zw/0DfQ4FdbJGt7qYYRnWnA=";
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
