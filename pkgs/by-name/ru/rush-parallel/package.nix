{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rush-parallel";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    rev = "v${version}";
    hash = "sha256-u3KGjZ5C8jDuAKE/dy4zR+EEFb35aJtj2YkwIb+kad4=";
  };

  vendorHash = "sha256-zCloMhjHNkPZHYX1e1nx072IYbWHFWam4Af0l0s8a6M=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A cross-platform command-line tool for executing jobs in parallel";
    homepage = "https://github.com/shenwei356/rush";
    changelog = "https://github.com/shenwei356/rush/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "rush-parallel";
  };
}
