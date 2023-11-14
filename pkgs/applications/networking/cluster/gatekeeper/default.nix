{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gatekeeper";
  version = "3.13.3";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "gatekeeper";
    rev = "v${version}";
    hash = "sha256-kLDriWkzOX4mC4VTpkyEtMTpOSoR0BsCwVeWLCfaY5w=";
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
