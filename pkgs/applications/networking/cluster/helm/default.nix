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
  version = "3.20.2";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YF5djCmCoPdLlEa/cksQgGtscEmIsQTiRqYZNyFjsEY=";
  };
  vendorHash = "sha256-kqx23LekpuZJFisVZUoXBY9vHh9zviKyaW5NSa4ecxM=";

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

  overrideModAttrs = _: {
    # the goModules derivation will otherwise inherit the preBuild phase defined above
    preBuild = "";
  };

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # restore ldflags for tests
    ldflags="''${old_ldflags}"

    # skipping version tests because they require dot git directory
    substituteInPlace cmd/helm/version_test.go \
      --replace-fail "TestVersion" "SkipVersion"
    # skipping plugin tests
    substituteInPlace cmd/helm/plugin_test.go \
      --replace-fail "TestPluginDynamicCompletion" "SkipPluginDynamicCompletion" \
      --replace-fail "TestLoadPlugins" "SkipLoadPlugins"
    substituteInPlace cmd/helm/helm_test.go \
      --replace-fail "TestPluginExitCode" "SkipPluginExitCode"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # skipping as test fails in sandbox
    substituteInPlace cmd/helm/dependency_build_test.go \
      --replace-fail "TestDependencyBuildCmd" "SkipDependencyBuildCmd"
    substituteInPlace cmd/helm/dependency_update_test.go \
      --replace-fail "TestDependencyUpdateCmd" "SkipDependencyUpdateCmd"
    # skipping as test fails in sandbox
    substituteInPlace cmd/helm/install_test.go \
      --replace-fail "TestInstall" "SkipInstall"
    # skipping as test fails in sandbox
    substituteInPlace cmd/helm/pull_test.go \
      --replace-fail "TestPullCmd" "SkipPullCmd" \
      --replace-fail "TestPullWithCredentialsCmd" "SkipPullWithCredentialsCmd"
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
