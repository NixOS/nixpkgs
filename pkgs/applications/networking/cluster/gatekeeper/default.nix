{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gatekeeper";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "gatekeeper";
    rev = "v${version}";
    sha256 = "sha256-hZ8PBJ+6G0A5tVrJfxy2rODxOxQarQg6mxG3sQCqjfY=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "cmd/gator" ];

  postInstall = ''
    installShellCompletion --cmd gator \
      --bash <($out/bin/gator completion bash) \
      --fish <($out/bin/gator completion fish) \
      --zsh <($out/bin/gator completion zsh)
  '';

  meta = with lib; {
    description = "Policy Controller for Kubernetes";
    homepage = "https://github.com/open-policy-agent/gatekeeper";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
