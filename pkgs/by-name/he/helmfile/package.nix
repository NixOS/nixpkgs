{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pluginsDir ? null,
}:

buildGoModule (finalAttrs: {
  pname = "helmfile";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fSFx4N8wN+gNITf8Ebthb3I3aDzpPY7MaljOBC3BUBM=";
  };

  vendorHash = "sha256-YGFLOlev/sX/LA9+9Y3+lsMLsLtMr7xm+uqUuV4xCaY=";

  proxyVendor = true; # darwin/linux hash mismatch

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X go.szostok.io/version.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (pluginsDir != null) makeWrapper;

  postInstall =
    lib.optionalString (pluginsDir != null) ''
      wrapProgram $out/bin/helmfile \
        --set HELM_PLUGINS "${pluginsDir}"
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd helmfile \
        --bash <($out/bin/helmfile completion bash) \
        --fish <($out/bin/helmfile completion fish) \
        --zsh <($out/bin/helmfile completion zsh)
    '';

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
      yurrriq
    ];
  };
})
