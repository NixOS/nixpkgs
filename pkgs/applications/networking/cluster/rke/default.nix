{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-e4YR3vYpaRVhwvBY8VwLp3XNXxnwYlS14VP0gSyLvJA=";
  };

  vendorHash = "sha256-++4d87ARL1czjL9I/AuodIP2PmbjjAQ5jf5x2bP16yQ=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X=main.VERSION=v${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rancher/rke";
    description = "Extremely simple, lightning fast Kubernetes distribution that runs entirely within containers";
    mainProgram = "rke";
    changelog = "https://github.com/rancher/rke/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
