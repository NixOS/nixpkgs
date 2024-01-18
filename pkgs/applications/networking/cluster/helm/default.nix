{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, kubernetes-helm
}:

buildGoModule rec {
  pname = "kubernetes-helm";
  version = "3.13.3";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-tU6RdVdcOvNYgnVmeDVKVuKY5GLeqVzpleq6qNwD2yI=";
  };
  vendorHash = "sha256-ve2T2O9cISshAe5uAyXYZ6Mbb1TPhOqhV8vkF5uMrhY=";

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w"
    "-s"
    "-X helm.sh/helm/v3/internal/version.version=v${version}"
    "-X helm.sh/helm/v3/internal/version.gitCommit=${src.rev}"
  ];

  /* tests have v1.20.0 hardcoded.
     since we *only* need it for tests and checkFlags comes last
     this effectivly overrides it only for tests.
   */

  # this sets k8sVersionMajor/Minor based on the k8s.io/client-go version
  # ref https://github.com/helm/helm/blob/276121c8693b48978eae5c09602b1e74d9a2a7e6/Makefile#L62
  postConfigure = ''
    K8S_MODULES_VER=$(go list -f '{{.Version}}' -m k8s.io/client-go)
    K8S_MODULES_VER=''${K8S_MODULES_VER//"."/" "}
    K8S_MODULES_VER=''${K8S_MODULES_VER//"v"/""}
    K8S_MODULES_MAJOR_VER=$(( $(echo "$K8S_MODULES_VER" | cut -d" " -f1) + 1 ))
    K8S_MODULES_MINOR_VER=$(echo "$K8S_MODULES_VER" | cut -d" " -f2)
    ldflags="$ldflags -X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="$ldflags -X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMinor=''${K8S_MODULES_MINOR_VER}"
    ldflags="$ldflags -X helm.sh/helm/v3/pkg/chartutil.k8sVersionMajor=''${K8S_MODULES_MAJOR_VER}"
    ldflags="$ldflags -X helm.sh/helm/v3/pkg/chartutil.k8sVersionMinor=''${K8S_MODULES_MINOR_VER}"
  '';

  checkFlags = [
    "-X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMajor=20"
    "-X helm.sh/helm/v3/pkg/lint/rules.k8sVersionMinor=0"
    "-X helm.sh/helm/v3/pkg/chartutil.k8sVersionMajor=20"
    "-X helm.sh/helm/v3/pkg/chartutil.k8sVersionMinor=0"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
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
  postInstall = ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    $out/bin/helm completion fish > helm.fish
    installShellCompletion helm.{bash,zsh,fish}
  '';

  passthru.tests.version = testers.testVersion {
    package = kubernetes-helm;
    command = "helm version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/kubernetes/helm";
    description = "A package manager for kubernetes";
    mainProgram = "helm";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert Frostman Chili-Man techknowlogick ];
  };
}
