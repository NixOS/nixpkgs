{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.23.3";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-78XvVPWhsvu7shbU2fJ+/7NnGxUXLLOeR28OPkUUw2A=";
  };

  vendorHash = "sha256-Y5HmoxMLs2rvpLycH5bMd9awHrNeIOkwn7m53hCAWug=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
