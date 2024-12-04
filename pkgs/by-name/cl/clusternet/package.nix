{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "clusternet";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "clusternet";
    repo = "clusternet";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZjFybox6BeezDj+Jvb6MRfaTRozpXGUIG1n1GDVS4aM=";
  };

  vendorHash = "sha256-hY4bgQXwKjL4UT3omDYuxy9xN9XOr00mMvGssKOSsG4=";

  ldFlags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CNCF Sandbox Project for managing your Kubernetes clusters";
    homepage = "https://github.com/clusternet/clusternet";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
