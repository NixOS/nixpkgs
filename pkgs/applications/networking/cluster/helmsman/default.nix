{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-4oJ/undqDSNn+Xn8eFEgOx+7263tmdXTHxXBkyFLpsE=";
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
