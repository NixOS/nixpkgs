{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Xj2MY80cCw+6no+qaqkiOoZAXlbkY8VVO+aDP85SLrI=";
  };

  vendorHash = "sha256-zXoRpVUQ16mtwAdStT6BnZLdd6RzZT5hP/Z4Yq2iUx8=";

  ldflags = [ "-s" "-w" "-X github.com/kubefirst/runtime/configs.K1Version=v${version}"];

  doCheck = false;

  meta = with lib; {
    description = "The Kubefirst CLI creates instant GitOps platforms that integrate some of the best tools in cloud native from scratch.";
    homepage = "https://github.com/kubefirst/kubefirst/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
