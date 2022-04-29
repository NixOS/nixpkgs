{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-njo5LlowlgWFK5G2lpgi7hdxtnSs8f5cT0oHI7bJxNc=";
  };

  vendorSha256 = "sha256-F+b4EXAxa4+O6yepx+9eRrdq294ZcQ+sODFUCKYpSuo=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
