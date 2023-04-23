{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.152.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-y7IM9YMbJvDmCwzR4Iz5losKberxtGkMfyxpyuBEb+o=";
  };

  vendorHash = "sha256-GRTtpZ4du3FNGpD+LArmNkJFeHs72jkYKYbvp73I/5s=";

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
    platforms = lib.platforms.unix;
  };
}
