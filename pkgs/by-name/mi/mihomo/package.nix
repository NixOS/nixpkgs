{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.5";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-eINcvVnWMDbviqNpD+SmtDYVQjLZgjaAdX9NrRAf0Ww=";
  };

  vendorHash = "sha256-xGaJ9iAP6Q8L6oC6LqEwi69Bd7H+bjSykGXckkZL92k=";

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
