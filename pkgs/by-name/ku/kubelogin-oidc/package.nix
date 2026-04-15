{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubelogin";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v6kNz75+xRQHfTfBKpKaNZodQzZNmJiF+WX0wJfGZ2M=";
  };

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  vendorHash = "sha256-f9Umpdlb6m38J05CanNJktS1T31SBSy1T1rOCzBUYkQ=";

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
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      nevivurn
    ];
  };
})
