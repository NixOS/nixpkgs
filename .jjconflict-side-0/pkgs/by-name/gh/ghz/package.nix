{ lib, buildGoModule, fetchFromGitHub, testers, ghz }:

buildGoModule rec {
  pname = "ghz";
  version = "0.120.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
    sha256 = "sha256-EzyQbMoR4veHbc9VaNfiXMi18wXbTbDPfDxo5NCk7CE=";
  };

  vendorHash = "sha256-7TrYWmVKxHKVTyiIak7tRYKE4hgG/4zfsM76bJRxnAk=";

  subPackages = [ "cmd/ghz" "cmd/ghz-web" ];

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
