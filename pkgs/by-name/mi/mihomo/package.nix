{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.4";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    tag = "v${version}";
    hash = "sha256-A/+BUnW7ge4y99W2rAUBAAqxO1L0M9oO0WSnLN1NnXQ=";
  };

  vendorHash = "sha256-VBDVtzI3GwxviLaAVUboHTtHaMQviiCUnB7ncgri+xc=";

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

  meta = with lib; {
    description = "Rule-based tunnel in Go";
    homepage = "https://github.com/MetaCubeX/mihomo/tree/Alpha";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "mihomo";
  };
}
