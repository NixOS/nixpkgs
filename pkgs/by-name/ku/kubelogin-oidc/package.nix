{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubelogin";
  version = "1.36.3";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VgsUQcFUbtZSZuar7K/ErJRsJZ0GvyIEixGGhF+hLnY=";
  };

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  vendorHash = "sha256-29D31EKO2Y6TXj607Tf3O5dGBHyrMyXoC5tWEKqvbbA=";

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
