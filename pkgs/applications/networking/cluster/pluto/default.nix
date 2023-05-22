{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
  version = "5.16.3";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    sha256 = "sha256-TlXwjgk+sT5lvswbDKjun0PhkfqDfk1IzGZ9NCMdw9s=";
  };

  vendorHash = "sha256-ahneuZExefFKGYDxa+F8IhKPDjw8+kdZ5Hj+k1BDxcU=";

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
