{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.33";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-O2OJ0WFt0T32yOIT1El+ACJWVm2oAJOjU1JTDXb2IEo=";
  };

  vendorHash = "sha256-wPkqyp2iuA762qID2FK3xWOMU5ZNxAle8saCmZzpeSI=";

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
    maintainers = with lib.maintainers; [
      oluceps
      levihuayuzhang
    ];
    mainProgram = "mihomo";
  };
}
