{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-M33ngnpxR3fQNsAkef4Rs4I3wNpOu5wTxbl48gL88F8=";
  };

  vendorHash = "sha256-nFWMw/FpaALp347z5dO8509fJCVISwS6z57JfQ+p3Dg=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
