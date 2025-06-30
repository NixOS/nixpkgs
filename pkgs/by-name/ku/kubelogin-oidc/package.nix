{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    tag = "v${version}";
    hash = "sha256-H/mHC2BwDoHVZ104NNJejhDTihaP3uIcsZokw4yKoz0=";
  };

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-9yofq5B4Lv/WqD7uwiiR2C88o/q8sTjgph3efYRyKYE=";

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
