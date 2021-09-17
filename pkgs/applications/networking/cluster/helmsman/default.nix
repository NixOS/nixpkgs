{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-7WN4YjhPbsFZfoFuZzsN85a+kdEVlEzQ9CfWh4nxxTs=";
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
