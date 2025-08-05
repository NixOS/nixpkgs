{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  fetchpatch,
}:

buildGoModule rec {
  pname = "mihomo";
  version = "1.19.11";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "mihomo";
    rev = "v${version}";
    hash = "sha256-nt2bnfKzGU+6gUaSqHfnbCnWLMDoAcISmlNYFeM4Xu8=";
  };

  patches = [
    # https://github.com/MetaCubeX/mihomo/pull/2178
    (fetchpatch {
      url = "https://github.com/MetaCubeX/mihomo/commit/63ad95e10f40ffc90ec93497aac562765af7a471.patch";
      hash = "sha256-ZE2dlr0t//Q1CVy2ql/TWuLEALdF1ZCYTOVK87bKWQg=";
    })
    # https://github.com/MetaCubeX/mihomo/pull/2177
    (fetchpatch {
      url = "https://github.com/MetaCubeX/mihomo/commit/b06ec5bef810ec8d009f52428188440df0484ce4.patch";
      hash = "sha256-XQhlST4pa//+Bg5hWc2zADulz8FeEiHwB99Rw9o24b0=";
    })
  ];

  vendorHash = "sha256-k/Zjnq07+Sg+dwwcAf+ziInaDvlXn3bEG+QuxZ5lcM8=";

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
