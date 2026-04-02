{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.22";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-HRFtKx9g7AsBPl3HlOf+2giDc6a7e4YmQZlg4hElfdI=";
  };

  vendorHash = "sha256-K5lC6bvetwaXvufa+FU+noXWXBem/IZ1pkl2eLo7vTc=";

  excludedPackages = [ "./test" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/metacubex/mihomo/constant.Version=${version}"
  ];

  tags = [
    "with_gvisor"
  ];

  # network required
  doCheck = false;

  passthru.tests = {
    mihomo = nixosTests.mihomo;
  };

  meta = {
    description = "Rule-based tunnel in Go";
    homepage = "https://github.com/MetaCubeX/mihomo/tree/Alpha";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "mihomo";
  };
}
