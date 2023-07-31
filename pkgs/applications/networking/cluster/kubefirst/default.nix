{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WlY9CdMY5fgEkXc/d/aUxr5c93oKd3vWQkUlX1jWaZo=";
  };

  vendorHash = "sha256-vIIaiHciA7ZPW0GWJNL/wx0siiNfXK16jYjMkMDfywE=";

  ldflags = [ "-s" "-w" "-X github.com/kubefirst/runtime/configs.K1Version=v${version}"];

  doCheck = false;

  meta = with lib; {
    description = "The Kubefirst CLI creates instant GitOps platforms that integrate some of the best tools in cloud native from scratch.";
    homepage = "https://github.com/kubefirst/kubefirst/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
