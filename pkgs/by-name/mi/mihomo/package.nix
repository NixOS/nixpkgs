{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.20";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-w1W8zClaiHA0EdAm4sf8Va11pxjXFFwmnSUyb7UWd74=";
  };

  vendorHash = "sha256-MrHUkwBxGgmKPsTXFM32q8PyXmHJiFvSwFmxRA1kdZM=";

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
