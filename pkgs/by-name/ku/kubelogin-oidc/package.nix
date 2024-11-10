{
  lib,
  buildGo123Module,
  fetchFromGitHub,
}:

buildGo123Module rec {
  pname = "kubelogin";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    rev = "v${version}";
    hash = "sha256-aoLPT3lX+q426QlxAPsjeQyTZMnmqMGh85jJPU7lQVU=";
  };

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-gr+SsC7MiLj/MZ8kca5Hcfge+7Pm4y963TfwyKHEhBY=";

  # test all packages
  preCheck = ''
    unset subPackages
  '';

  # Rename the binary instead of symlinking to avoid conflict with the
  # Azure version of kubelogin
  postInstall = ''
    mv $out/bin/kubelogin $out/bin/kubectl-oidc_login
  '';

  meta = {
    description = "Kubernetes credential plugin implementing OpenID Connect (OIDC) authentication";
    mainProgram = "kubectl-oidc_login";
    inherit (src.meta) homepage;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      nevivurn
    ];
  };
}
