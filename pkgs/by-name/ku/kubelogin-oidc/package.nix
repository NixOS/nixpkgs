{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    rev = "v${version}";
    hash = "sha256-LfMxfXM3L4r0S8eDQVgFO1jTf/BcYpxxQSMl4zRh/yA=";
  };

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-o+74+PnwhMe2oMfFLMD95R4m3gMjQS2d4pAvCEjh05U=";

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
