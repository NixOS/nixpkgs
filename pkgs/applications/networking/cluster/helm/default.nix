{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-helm";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZSO/9pWiG87zJEZ6ODG2AFIM2zho+0CePOeRTvQ1q0E=";
  };
  vendorHash = "sha256-wcS0NoSF5R5ogYc2xCc4hOWCnkhWkDBpUnfr1GpNlao=";

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w"
    "-s"
    "-X helm.sh/helm/v4/internal/version.version=v${finalAttrs.version}"
    "-X helm.sh/helm/v4/internal/version.metadata="
    "-X helm.sh/helm/v4/internal/version.gitCommit=${finalAttrs.src.rev}"
    "-X helm.sh/helm/v4/internal/version.gitTreeState=clean"
  ];

  preBuild = ''
    # set k8s version to client-go version, to match upstream
    K8S_MODULES_VER="$(go list -f '{{.Version}}' -m k8s.io/client-go)"
    K8S_MODULES_MAJOR_VER="$(($(cut -d. -f1 <<<"$K8S_MODULES_VER") + 1))"
    K8S_MODULES_MINOR_VER="$(cut -d. -f2 <<<"$K8S_MODULES_VER")"
    old_ldflags="''${ldflags}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/pkg/chart/v2/lint/rules.k8sVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/pkg/chart/v2/lint/rules.k8sVersionMinor=''${K8S_MODULES_MINOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/pkg/internal/v3/lint/rules.k8sVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/pkg/internal/v3/lint/rules.k8sVersionMinor=''${K8S_MODULES_MINOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/pkg/chart/common/util.k8sVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/pkg/chart/common/util.k8sVersionMinor=''${K8S_MODULES_MINOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/internal/version.kubeClientVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="''${ldflags} -X helm.sh/helm/v4/internal/version.kubeClientVersionMinor=''${K8S_MODULES_MINOR_VER}"
  '';

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # restore ldflags for tests
    ldflags="''${old_ldflags}"

    # skipping version tests because they require dot git directory
    substituteInPlace pkg/cmd/version_test.go \
      --replace "TestVersion" "SkipVersion"
    # skipping plugin tests
    substituteInPlace pkg/cmd/plugin_test.go \
      --replace "TestPluginDynamicCompletion" "SkipPluginDynamicCompletion" \
      --replace "TestLoadPlugins" "SkipLoadPlugins"
    substituteInPlace cmd/helm/helm_test.go \
      --replace "TestPluginExitCode" "SkipPluginExitCode"
  '';

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
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

  meta = {
    homepage = "https://github.com/helm/helm";
    description = "Package manager for kubernetes";
    mainProgram = "helm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rlupton20
      edude03
      saschagrunert
      Frostman
      Chili-Man
      techknowlogick
    ];
  };
})
