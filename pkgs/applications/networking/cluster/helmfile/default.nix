{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, pluginsDir ? null
}:

buildGoModule rec {
  pname = "helmfile";
  version = "0.155.1";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-6y+7Jrs/sIpxJjO9Zzv2ht1RprrqcBjwyOsCnqDHxUY=";
  };

  vendorHash = "sha256-MCx+6K3CqVfFEYgkxT1sFvy0vshpKwW07AUngEG2muk=";

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
    longDescription = ''
      Declaratively deploy your Kubernetes manifests, Kustomize configs,
      and charts as Helm releases in one shot.
    '';
    homepage = "https://helmfile.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
  };
}
