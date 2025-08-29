{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-GDPVrGWawzuOjTCtXIDFH2XUQ6Ot3i+w4x61QK3TyIE=";
  };

  vendorHash = "sha256-CekPp3Tmte08DdFulVTNxlh4OuWz+ObqQ9jDd5b+Qn8=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
