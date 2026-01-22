{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-uIIy4zSf6ply859aHVvlujqBWpN18FLZh+Vye3fbSoY=";
  };

  vendorHash = "sha256-Hl7cYZbs+rDS2+1ojgCUhLfBVGQ+ZhAApRczkUYOwVY=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devusb ];
  };
}
