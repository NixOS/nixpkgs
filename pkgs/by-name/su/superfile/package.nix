{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "superfile";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    rev = "v${version}";
    hash = "sha256-/MdcfZpYr7vvPIq0rqLrPRPPU+cyp2y0EyxQPf9znwQ=";
  };

  vendorHash = "sha256-8WGmksKH0rmfRH6Xxd0ACl1FS7YPphG7hsIB5/o38lQ=";

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
