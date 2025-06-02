{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bomber-go";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "devops-kung-fu";
    repo = "bomber";
    tag = "v${version}";
    hash = "sha256-q3x3duXc2++BvVul2a5fBTcPHWrOHpPOGHBUXL08syg=";
  };

  vendorHash = "sha256-jVdrvc48/Vt240EYk5PtZCjNGipX7M1qF8OJdpu/qI4=";

  ldflags = [
    "-w"
    "-s"
  ];

  checkFlags = [
    "-skip=TestEnrich" # Requires network access
  ];

  meta = {
    description = "Tool to scans Software Bill of Materials (SBOMs) for vulnerabilities";
    homepage = "https://github.com/devops-kung-fu/bomber";
    changelog = "https://github.com/devops-kung-fu/bomber/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    mainProgram = "bomber";
    maintainers = with lib.maintainers; [ fab ];
  };
}
