{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.3";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-NzxH6rgr85oHmkMxh3rLbYXJoQKOsngeTazAV3SvRCg=";
  };

  vendorHash = "sha256-dQNdOTFcfk53Snu01XLGB3PTiU1Ex/QQvykfopIdk2M=";

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
