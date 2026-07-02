{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubelogin";
  version = "1.36.2";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VzUnjqa3XnKSqcwd2jVwbQwGmyO5+YBwPIIxN0wj81A=";
  };

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  vendorHash = "sha256-/30B7krXl0HYm+nUqGtbhNb4L8utdorjZNGkfMCYs3k=";

  # test all packages
  preCheck = ''
    unset subPackages
  '';

  # Rename the binary instead of symlinking to avoid conflict with the
  # Azure version of kubelogin
  postInstall = ''
    mv $out/bin/kubelogin $out/bin/kubectl-oidc_login
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes credential plugin implementing OpenID Connect (OIDC) authentication";
    mainProgram = "kubectl-oidc_login";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      malteneuss
      nevivurn
    ];
  };
})
