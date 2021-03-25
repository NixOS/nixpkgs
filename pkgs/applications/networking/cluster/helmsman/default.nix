{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.6.5";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-FOBSGXVIb4mLDHMqOljZ04W0q/H/HOuFm9Cl2kK027s=";
  };

  vendorSha256 = "sha256-mktq5Dnk1mBO2yy5SeMDxa/akXdO5i2WafMTGtH53H8=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
