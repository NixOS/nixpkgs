{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-IYHzgP9KDNGlNe1znWKv/IST1if9Nnn2cP9rerAIgkY=";
  };

  vendorHash = "sha256-mJyriMf2/2J1ol4gBxgmEdNT1qWCBnwKwIB0yyubxc4=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
