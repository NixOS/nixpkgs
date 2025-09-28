{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-helm";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ssOebBeIFVd6N0CDWfAU3HN0j4Rw7twncokzorHWJig=";
  };
  vendorHash = "sha256-G3PLT2jE+Oitct5F+o/hr8GDAKWcvp23dcpezuBge6k=";

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w"
    "-s"
    "-X helm.sh/helm/v3/internal/version.version=v${finalAttrs.version}"
    "-X helm.sh/helm/v3/internal/version.gitCommit=${finalAttrs.src.rev}"
  ];

  preBuild = ''
    # set k8s version to client-go version, to match upstream
    K8S_MODULES_VER="$(go list -f '{{.Version}}' -m k8s.io/client-go)"
    K8S_MODULES_MAJOR_VER="$(($(cut -d. -f1 <<<"$K8S_MODULES_VER") + 1))"
    K8S_MODULES_MINOR_VER="$(cut -d. -f2 <<<"$K8S_MODULES_VER")"
    old_ldflags="''${ldflags}"
    ldflags="''${ldflags} -X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMinor=''${K8S_MODULES_MINOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v3/pkg/chartutil.k8sVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v3/pkg/chartutil.k8sVersionMinor=''${K8S_MODULES_MINOR_VER}"
  '';

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # restore ldflags for tests
    ldflags="''${old_ldflags}"

    # skipping version tests because they require dot git directory
    substituteInPlace cmd/helm/version_test.go \
      --replace "TestVersion" "SkipVersion"
    # skipping plugin tests
    substituteInPlace cmd/helm/plugin_test.go \
      --replace "TestPluginDynamicCompletion" "SkipPluginDynamicCompletion" \
      --replace "TestLoadPlugins" "SkipLoadPlugins"
    substituteInPlace cmd/helm/helm_test.go \
      --replace "TestPluginExitCode" "SkipPluginExitCode"
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    $out/bin/helm completion fish > helm.fish
    installShellCompletion helm.{bash,zsh,fish}
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "helm version";
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    homepage = "https://github.com/helm/helm";
    description = "Package manager for kubernetes";
    mainProgram = "helm";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rlupton20
      edude03
      saschagrunert
      Frostman
      Chili-Man
      techknowlogick
    ];
  };
})
