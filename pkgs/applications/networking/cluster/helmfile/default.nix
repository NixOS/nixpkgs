{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, pluginsDir ? null
}:

buildGoModule rec {
  pname = "helmfile";
  version = "0.158.0";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-768rlhkh8scQbzLvWyjyQSba4zCY/ydYreve+HmcFgw=";
  };

  vendorHash = "sha256-ip01Uj720Sa11ni+8//U1PkHgiY6ttftvMHdxZgfKLk=";

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
