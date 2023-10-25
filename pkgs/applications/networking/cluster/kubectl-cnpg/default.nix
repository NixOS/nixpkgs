{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    sha256 = "sha256-PFibPL5jBbdGgULiqtt5tKYy3UWsldnbCN2LJpxat60=";
  };

  vendorSha256 = "sha256-jD8p5RWbCMPmZec3fEsGa8kevTi1curBazlEDvjeuq8=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
