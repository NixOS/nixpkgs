{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "lightning-pool";
  version = "0.6.4-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ proofofkeags ];
  };
})
