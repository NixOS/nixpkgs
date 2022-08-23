{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-AfJf+o73iR0aHNFfB7f0S+cc5VeEOAjD0Ou44WHTTAg=";
  };

  vendorSha256 = "sha256-Ijy9UxT746Bi6x+aXxKNRxzAo5yRTV/6nbVjk9i4ffk=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
