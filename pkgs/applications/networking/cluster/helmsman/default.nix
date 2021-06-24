{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-SGVch7mMtHi5GYFOrSss4dk29aRTQmBzkPYOetPdF88=";
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
