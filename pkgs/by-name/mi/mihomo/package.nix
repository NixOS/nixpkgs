{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.23";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-0KaTf/FXlLBxbq6ViNkD4uSIKJ7pNxEBMFIYL983hAY=";
  };

  vendorHash = "sha256-4xu/ZcoFCpO226tVfhVwkXaTEIyblFjKezX/haHjyNE=";

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
