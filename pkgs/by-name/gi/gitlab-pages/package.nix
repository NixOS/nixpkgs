{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "18.5.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    hash = "sha256-UrVH5Ky5aiqquQ2o6bSkqLD4ULl9/vUViOoACantT1Q=";
  };

  vendorHash = "sha256-VWD/AXqEVWo7G9p1q1BM2LUNwAFmkPm+Gm2s9EPu6nM=";
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
