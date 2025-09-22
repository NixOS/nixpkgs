{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.31.2-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    hash = "sha256-xhvGsAvcJqjSyf32Zo9jJUoHCN/5mWliLqcyN3GEjD0=";
  };

  vendorHash = "sha256-Rb0P2mPrvOII5Ck4rtB4/gpymVmwuM1rH8sxLt0zDhs=";

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
    maintainers = with maintainers; [ proofofkeags ];
  };
}
