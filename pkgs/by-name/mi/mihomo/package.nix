{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.16";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-tao4/caGLbqHMvD2I9mSK0SskyKEpSGZ9uz8B1ViUcA=";
  };

  vendorHash = "sha256-tKOiSKOorJ9vX83FNCUE4xQcO2cN33v43zYSoo+lKZY=";

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
