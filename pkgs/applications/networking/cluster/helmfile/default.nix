{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pluginsDir ? null,
}:

buildGoModule rec {
  pname = "helmfile";
  version = "0.171.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    hash = "sha256-zZt0YxGbDqIhg2tXjQo5QnD09ASOUgFyQ1uWbGcujkc=";
  };

  vendorHash = "sha256-sGqnM40Y1nr9dXcSSC1lkwh1ToRLpCMiWJhyMcxxH9U=";

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
