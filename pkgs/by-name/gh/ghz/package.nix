{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghz,
}:

buildGoModule (finalAttrs: {
  pname = "ghz";
  version = "0.121.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hfHhsargP/odmpbfO24aDXr5m9VeDNOYyi1n9ji2trU=";
  };

  vendorHash = "sha256-eu0YPKddYfjbOkF0yrUPu2PsjsyIn2pBm9+CDrRlB2k=";

  subPackages = [
    "cmd/ghz"
    "cmd/ghz-web"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = ghz;
    };
    web-version = testers.testVersion {
      package = ghz;
      command = "ghz-web -v";
    };
  };

  meta = {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = lib.licenses.asl20;
  };
})
