<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, pluginsDir ? null
}:

buildGoModule rec {
  pname = "helmfile";
  version = "0.156.0";
=======
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.153.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-MrDhOsjXo4aaeWSo/WNheUqom7kF2MzyaqeZXVAAzz4=";
  };

  vendorHash = "sha256-hMoBwA9KmQSBJkEu3UAxM1wi6RRHZdUhYqri5JGwEmw=";
=======
    sha256 = "sha256-XdRA2lFkO98llH1A5GW5wgFsggvO5ZBbNXYZR9eoHgM=";
  };

  vendorHash = "sha256-gm/fVtmcmVHyJnzODwfgJeCaFKk2iLjTpLKtdABqdCE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X go.szostok.io/version.version=v${version}" ];

<<<<<<< HEAD
  nativeBuildInputs =
    [ installShellFiles ] ++
    lib.optional (pluginsDir != null) makeWrapper;

  postInstall = lib.optionalString (pluginsDir != null) ''
    wrapProgram $out/bin/helmfile \
      --set HELM_PLUGINS "${pluginsDir}"
  '' + ''
=======
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    platforms = lib.platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
