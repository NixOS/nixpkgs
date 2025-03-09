{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "superfile";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    rev = "v${version}";
    hash = "sha256-3zQDErfst0CAE9tdOUtPGtGWuOo/K8x/M+r6+RPrlCM=";
  };

  vendorHash = "sha256-DU0Twutepmk+8lkBM2nDChbsSHh4awt5m33ACUtH4AQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${src.rev}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      momeemt
      redyf
    ];
    mainProgram = "superfile";
  };
}
