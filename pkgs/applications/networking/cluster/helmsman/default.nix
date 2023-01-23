{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-QhAmedSDBi1aRNmp4LR5Xv4HMzcextzT67g9nxN4eko=";
  };

  vendorHash = "sha256-bVgYj0e/z57sIvVZXAzLkKqKLa0Pe0CT57Vc7Df1oWE=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
