{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.150.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-7wCt+JAuozsd+LifLArfPNwiKK/tDvgwpIwVCW4nU3Y=";
  };

  vendorSha256 = "sha256-vLLS+/Xfnlt6cvkNvXKX3DVLku1Q4bRCiv2vMTfOnfw=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/helmfile/helmfile/pkg/app/version.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd helmfile \
      --bash <($out/bin/helmfile completion bash) \
      --fish <($out/bin/helmfile completion fish) \
      --zsh <($out/bin/helmfile completion zsh)
  '';

  meta = {
    description = "Declarative spec for deploying Helm charts";
    longDescription = ''
      Declaratively deploy your Kubernetes manifests, Kustomize configs,
      and charts as Helm releases in one shot.
    '';
    homepage = "https://helmfile.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}
