{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-6ISQsCLiyW4GDFuVnQ+UWwfN2ZqW3m3ZN/FrYOd83DE=";
  };

  vendorSha256 = "sha256-AjRKPsCPHCDEPjqMJtl/hkrcGepj3neC9eSgsbT/DIc=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
