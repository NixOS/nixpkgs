{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.24.2";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-XXlqtqn2PiBo2YHaBnwt1BpTnON+ActIuLO0EFDAxMw=";
  };

  vendorHash = "sha256-FpCM2R/bQ1BScYHEK5xaO0kZ/hCUZaUDhu6XoTNPn2o=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
