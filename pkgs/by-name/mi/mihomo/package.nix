{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.17";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-NnRudhRW8ecfWCbzigF+B3/a7eiZygl4Oy0zNhhlFWs=";
  };

  vendorHash = "sha256-WwbuNplMkH5wotpHasQbwK85Ymh6Ke4WL1LTLDWvRFk=";

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
