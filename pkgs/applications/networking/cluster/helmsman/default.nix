{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-mXc3CVKh4pFAZVppvk5TTg6s6dOA2Gv+ROLNV37DAl4=";
  };

  vendorHash = "sha256-zn8q3HpyQWNsksYbqJcgnjOxaBVUr3dIYHk+FAalNxA=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
  };
}
