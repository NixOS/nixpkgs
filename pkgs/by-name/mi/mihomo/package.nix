{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-/fFVUI++OhOer5DrvcXO+R+4whtb5+3Qg3e4+ikJr1Y=";
  };

  vendorHash = "sha256-k4xB/jO78VGD+n9HtuoWXoXB+kZCEyPKJTTwj32nGIw=";

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
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/MetaCubeX/mihomo/tree/Alpha";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "mihomo";
  };
}
