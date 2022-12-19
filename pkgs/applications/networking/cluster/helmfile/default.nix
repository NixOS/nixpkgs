{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.149.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-d3wb1m65TaWrRE23LDytnkBuAcHazfzwTKwINhC9hW0=";
  };

  vendorSha256 = "sha256-akxA1AeYuaIKBAgt+u5fWcFYYP1YVMT79l5WwTn1bnI=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/helmfile/helmfile/pkg/app/version.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mkdir completions
    $out/bin/helmfile completion bash > completions/helmfile || true
    $out/bin/helmfile completion zsh > completions/_helmfile || true
    $out/bin/helmfile completion fish > completions/helmfile.fish || true
    installShellCompletion --cmd helmfile \
      --bash completions/helmfile  \
      --zsh completions/_helmfile \
      --fish completions/helmfile.fish
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
