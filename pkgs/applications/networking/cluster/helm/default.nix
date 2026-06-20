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
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k2lZXdWYnewNiZdLNQrC5j9A3JkvYCwMY486QxjCpaw=";
  };

  vendorHash = "sha256-XIKQF9PWgxKJUt66wQ/mPhWVfJnra0vV9ZuyclgQ21U=";

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

  overrideModAttrs = _: {
    # the goModules derivation will otherwise inherit the preBuild phase defined above
    preBuild = "";
  };

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # restore ldflags for tests
    ldflags="''${old_ldflags}"

    patchShebangs pkg/cmd/testdata/helmhome/helm/plugins/exitwith/exitwith.sh

    # skipping version tests because they require dot git directory
    substituteInPlace pkg/cmd/version_test.go \
      --replace-fail "TestVersion" "SkipVersion"
    # skipping plugin tests
    substituteInPlace pkg/cmd/plugin_test.go \
      --replace-fail "TestPluginDynamicCompletion" "SkipPluginDynamicCompletion" \
      --replace-fail "TestLoadCLIPlugins" "SkipLoadCLIPlugins"
    substituteInPlace cmd/helm/helm_test.go \
      --replace-fail "TestCliPluginExitCode" "TestCliPluginExitCode"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # skipping as test fails in sandbox
    substituteInPlace pkg/cmd/dependency_build_test.go \
      --replace-fail "TestDependencyBuildCmd" "SkipDependencyBuildCmd"
    substituteInPlace pkg/cmd/dependency_update_test.go \
      --replace-fail "TestDependencyUpdateCmd" "SkipDependencyUpdateCmd"
    # skipping as test fails in sandbox
    substituteInPlace pkg/cmd/install_test.go \
      --replace-fail "TestInstall" "SkipInstall"
    # skipping as test fails in sandbox
    substituteInPlace pkg/cmd/pull_test.go \
      --replace-fail "TestPullCmd" "SkipPullCmd" \
      --replace-fail "TestPullWithCredentialsCmd" "SkipPullWithCredentialsCmd"
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
