{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "lightning-pool";
  version = "0.6.4-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${version}";
    hash = "sha256-lSc/zOZ5VpmaZ7jrlGvSaczrgOtAMS9tDUxcMoFdBmQ=";
  };

  vendorHash = "sha256-DD27zUW524qe9yLaVPEzw/c4sSzlH89HMw0PdtNYEhg=";

  subPackages = [
    "cmd/pool"
    "cmd/poold"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = licenses.mit;
    maintainers = with maintainers; [
      proofofkeags
      prusnak
    ];
  };
}
