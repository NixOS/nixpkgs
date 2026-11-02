{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
}:

buildGoModule (finalAttrs: {
  pname = "argocd";
  version = "3.5.6";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gv/7K3eU80ncOyHq/OPKneQTOVcsuYkJ2F9YiqNOdEU=";
  };

  ui = stdenv.mkDerivation (uiAttrs: {
    pname = "argocd-ui";
    inherit (finalAttrs) version;
    src = finalAttrs.src + "/ui";

    pnpmDeps = fetchPnpmDeps {
      inherit (uiAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = "sha256-WO0wDFGESRaWVbiXkHm6oX1CNAvYiScL60Vta4/FVAI=";
    };

    nativeBuildInputs = [
      pnpmConfigHook
      pnpm_10
      nodejs
    ];

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/dist
      runHook postInstall
    '';
  });

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-RxBSSnCBcFEXP5iZo6nr5FihOIJH4dYB2bMHbvqANQc=";

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
    export KUBECTL_VERSION=$(go list -m -f '{{.Version}}' k8s.io/kubectl)
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
