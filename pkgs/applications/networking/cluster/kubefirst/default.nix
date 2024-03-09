{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CW+p6hcXHVUlMuxXiwHtp4/iY/VYe/64TMY2UyARpG4=";
  };

  vendorHash = "sha256-hI6f7Iyo4sWgSSRLDROLhvI/g1wLc1oVmVt2pQ5Ptbk=";

  ldflags = [ "-s" "-w" "-X github.com/kubefirst/runtime/configs.K1Version=v${version}"];

  doCheck = false;

  meta = with lib; {
    description = "The Kubefirst CLI creates instant GitOps platforms that integrate some of the best tools in cloud native from scratch.";
    homepage = "https://github.com/kubefirst/kubefirst/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
