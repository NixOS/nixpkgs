{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "clusternet";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "clusternet";
    repo = "clusternet";
    tag = "v${version}";
    hash = "sha256-uhRnJyUR7lbJvVxd3YNVxmTSTDksQsVcM5G8ZKO7Xbk=";
  };

  vendorHash = "sha256-hY4bgQXwKjL4UT3omDYuxy9xN9XOr00mMvGssKOSsG4=";

  ldFlags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CNCF Sandbox Project for managing your Kubernetes clusters";
    homepage = "https://github.com/clusternet/clusternet";
    license = licenses.asl20;
    maintainers = with maintainers; [ genga898 ];
  };
}
