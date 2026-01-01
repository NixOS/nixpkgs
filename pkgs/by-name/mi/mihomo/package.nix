{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
<<<<<<< HEAD
  version = "1.19.17";
=======
  version = "1.19.16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NnRudhRW8ecfWCbzigF+B3/a7eiZygl4Oy0zNhhlFWs=";
  };

  vendorHash = "sha256-WwbuNplMkH5wotpHasQbwK85Ymh6Ke4WL1LTLDWvRFk=";
=======
    hash = "sha256-tao4/caGLbqHMvD2I9mSK0SskyKEpSGZ9uz8B1ViUcA=";
  };

  vendorHash = "sha256-tKOiSKOorJ9vX83FNCUE4xQcO2cN33v43zYSoo+lKZY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Rule-based tunnel in Go";
    homepage = "https://github.com/MetaCubeX/mihomo/tree/Alpha";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
=======
  meta = with lib; {
    description = "Rule-based tunnel in Go";
    homepage = "https://github.com/MetaCubeX/mihomo/tree/Alpha";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oluceps ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mihomo";
  };
}
