{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-FRSypaZex55ABE+e23kvNZFTTn6Z8AEy8ag3atwMdEk=";
  };

  vendorHash = "sha256-mirnieBrrVwRccJDgelZvSfQaAVlTsttOh3nJBN6ev0=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
