{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    rev = "v${version}";
    hash = "sha256-IEKP5mHxJyGzlxNL4h0MR/Ge7g1kKidIjinYr+bL6as=";
  };

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-3hNc16zpazm9YqDx2M/RafCBLev2S8TzJzClGRkKydg=";

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
