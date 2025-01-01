{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, pluginsDir ? null
}:

buildGoModule rec {
  pname = "helmfile";
  version = "0.168.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    hash = "sha256-qpYTYOzQWhjuVANOPpLDsYZyhvRl6FnNQz5ssDZHohw=";
  };

  vendorHash = "sha256-pCP5PxxOLlqQBmqufpo6G69v4M+NxMpTlIUY6TnclVA=";

  proxyVendor = true; # darwin/linux hash mismatch

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X go.szostok.io/version.version=v${version}" ];

  nativeBuildInputs =
    [ installShellFiles ] ++
    lib.optional (pluginsDir != null) makeWrapper;

  postInstall = lib.optionalString (pluginsDir != null) ''
    wrapProgram $out/bin/helmfile \
      --set HELM_PLUGINS "${pluginsDir}"
  '' + ''
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
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
  };
}
