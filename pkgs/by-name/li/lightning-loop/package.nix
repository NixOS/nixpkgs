{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.28.8-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    hash = "sha256-zgKKYHDRYXPslPHay/V2DAL1jQfeX5qPWUQQtuvp1M0=";
  };

  vendorHash = "sha256-v7zSvCp63z+xZIuXbqHueamEBN/jZBr2Kysvq03e8L0=";

  subPackages = [
    "cmd/loop"
    "cmd/loopd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [
      proofofkeags
      prusnak
    ];
  };
}
