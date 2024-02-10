{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gatekeeper";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "gatekeeper";
    rev = "v${version}";
    hash = "sha256-Mt9bSgmqjj9KkJJW0F2tr2P8GtSy80h9CfMXvIxyKc4=";
  };

  vendorHash = null;

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
