{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  go-jsonnet,
}:

buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-P69tguBrFF/CSCOfHjCfBT5710oJdhZDh3kMCbc32eE=";
  };

  vendorHash = "sha256-j1fTOUpLx34TgzW94A/BctLrg9XoTtb3cBizhVJoEEI=";

  subPackages = [ "cmd/jsonnet*" ];

  passthru.tests.version = testers.testVersion {
    package = go-jsonnet;
    version = "v${version}";
  };

  meta = {
    description = "Implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nshalman
      aaronjheng
    ];
    mainProgram = "jsonnet";
  };
}
