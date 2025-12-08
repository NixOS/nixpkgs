{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghz,
}:

buildGoModule rec {
  pname = "ghz";
  version = "0.121.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
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
    "-X=main.version=${version}"
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

  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
  };
}
