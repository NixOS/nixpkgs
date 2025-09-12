{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  pluginsDir ? null,
}:

buildGo125Module rec {
  pname = "helmfile";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    hash = "sha256-7A/WPBXk17HCAr9F7UZwNO2+N4tvtfPo9wNwtw1HKy4=";
  };

  vendorHash = "sha256-CNvmIK8xUm1CdwdXU5FVUShmaA3CEgR4H7GmOH2KwzE=";

  proxyVendor = true; # darwin/linux hash mismatch

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X go.szostok.io/version.version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (pluginsDir != null) makeWrapper;

  postInstall =
    lib.optionalString (pluginsDir != null) ''
      wrapProgram $out/bin/helmfile \
        --set HELM_PLUGINS "${pluginsDir}"
    ''
    + ''
      installShellCompletion --cmd helmfile \
        --bash <($out/bin/helmfile completion bash) \
        --fish <($out/bin/helmfile completion fish) \
        --zsh <($out/bin/helmfile completion zsh)
    '';
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative spec for deploying Helm charts";
    mainProgram = "helmfile";
    longDescription = ''
      Declaratively deploy your Kubernetes manifests, Kustomize configs,
      and charts as Helm releases in one shot.
    '';
    homepage = "https://helmfile.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pneumaticat
      yurrriq
    ];
  };
}
