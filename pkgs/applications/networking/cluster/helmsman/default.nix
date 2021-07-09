{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-wzmn06nUycNaQ4tUEBd4q17M1CVC0+5X13rqF7zaHqU=";
  };

  vendorSha256 = "sha256-XHgdVFGIzbPPYgv/T4TtvDDbKAe3niev4S5tu/nwSqg=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
