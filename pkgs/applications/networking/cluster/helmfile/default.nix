{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.155.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-9YOgpXiZegimS81owjHW/in0NbxMTL+DQEgSBWdW7Rs=";
  };

  vendorHash = "sha256-ioZJr3v/8HhOEJJZpsCw5Gkbg9XvMMEOugyfRhevWBc=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X go.szostok.io/version.version=v${version}" ];

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
  };
}
