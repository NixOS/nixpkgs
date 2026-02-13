{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
}:

buildGoModule (finalAttrs: {
  pname = "argocd";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FvN4JCG/5SxpnmdEH9X1sMX5dNlp/x0ALNysv+LWroU=";
  };

  ui = stdenv.mkDerivation {
    pname = "argocd-ui";
    inherit (finalAttrs) version;
    src = finalAttrs.src + "/ui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/ui/yarn.lock";
      hash = "sha256-ekhSPWzIgFhwSw0bIlBqu8LTYk3vuJ9VM8eHc3mnHGM=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];

    postInstall = ''
      mkdir -p $out
      cp -r dist $out/dist
    '';
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-UYDGt7iTyDlq3lKEZAqFchO0IYV5kVlfbegWaHsA1Og=";

  # Set target as ./cmd per cli-local
  # https://github.com/argoproj/argo-cd/blob/master/Makefile
  subPackages = [ "cmd" ];

  ldflags =
    let
      packageUrl = "github.com/argoproj/argo-cd/v3/common";
    in
    [
      "-s"
      "-w"
      "-X ${packageUrl}.version=${finalAttrs.version}"
      "-X ${packageUrl}.buildDate=unknown"
      "-X ${packageUrl}.gitCommit=${finalAttrs.src.rev}"
      "-X ${packageUrl}.gitTag=${finalAttrs.src.rev}"
      "-X ${packageUrl}.gitTreeState=clean"
    ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    cp -r ${finalAttrs.ui}/dist ./ui
    stat ./ui/dist/app/index.html # Sanity check
  '';

  # set ldflag for kubectlVersion since it is needed for argo
  # Per https://github.com/search?q=repo%3Aargoproj%2Fargo-cd+%22KUBECTL_VERSION%3D%22+path%3AMakefile&type=code
  prePatch = ''
    export KUBECTL_VERSION=$(grep 'k8s.io/kubectl v' go.mod | cut -f 2 -d " " | cut -f 1 -d "=" )
    echo using $KUBECTL_VERSION
    ldflags="''${ldflags} -X github.com/argoproj/argo-cd/v3/common.kubectlVersion=''${KUBECTL_VERSION}"
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cmd" -T $out/bin/argocd
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/argocd version --client | grep ${finalAttrs.src.rev} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd argocd \
      --bash <($out/bin/argocd completion bash) \
      --fish <($out/bin/argocd completion fish) \
      --zsh <($out/bin/argocd completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative continuous deployment for Kubernetes";
    mainProgram = "argocd";
    downloadPage = "https://github.com/argoproj/argo-cd";
    homepage = "https://argo-cd.readthedocs.io/en/stable/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      shahrukh330
      qjoly
      FKouhai
    ];
  };
})
