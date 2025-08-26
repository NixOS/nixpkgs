{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    rev = "v${version}";
    sha256 = "sha256-99mVCuoog9ZkJoCCcUWkRJ2vA0IwftEcsSl6I02Qd4A=";
  };

  vendorHash = "sha256-se4vNVydYFYk07Shb3eRLnVmE82HG36cwFRYCdZiZPM=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    license = licenses.mit;
    maintainers = with maintainers; [ shift ];
  };
}
