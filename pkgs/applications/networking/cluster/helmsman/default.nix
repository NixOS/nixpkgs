{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.17.1";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-u/Fj3A81hH7i1yTg+kcqCPrwEkj0cyhZvNzRYURDoZU=";
  };

  vendorHash = "sha256-3eIMMKMvRzOSMvufETR9H1PnPDeEc+su8UuvbQJZ7kI=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    mainProgram = "helmsman";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
  };
}
