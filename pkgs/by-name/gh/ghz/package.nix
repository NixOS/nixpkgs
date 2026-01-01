{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghz,
}:

buildGoModule rec {
  pname = "ghz";
<<<<<<< HEAD
  version = "0.121.0";
=======
  version = "0.120.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-hfHhsargP/odmpbfO24aDXr5m9VeDNOYyi1n9ji2trU=";
  };

  vendorHash = "sha256-eu0YPKddYfjbOkF0yrUPu2PsjsyIn2pBm9+CDrRlB2k=";
=======
    sha256 = "sha256-EzyQbMoR4veHbc9VaNfiXMi18wXbTbDPfDxo5NCk7CE=";
  };

  vendorHash = "sha256-7TrYWmVKxHKVTyiIak7tRYKE4hgG/4zfsM76bJRxnAk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
