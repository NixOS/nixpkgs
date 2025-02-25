{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-pU8OgGmRzZEfcMOhMHXhwK+oA/6zyj7F7QZ0ZNJIjsQ=";
  };

  vendorHash = "sha256-sKYREfo107RYGACXn37X9ENz/rwkdiBswRlFN4Z20yY=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
