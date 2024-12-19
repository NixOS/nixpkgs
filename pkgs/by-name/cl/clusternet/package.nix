{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "clusternet";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "clusternet";
    repo = "clusternet";
    rev = "refs/tags/v${version}";
    hash = "sha256-6JZdFHMbdFm2uTlMbbi0y4rcVkbUZ6gSeK57v6MiL7M=";
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
