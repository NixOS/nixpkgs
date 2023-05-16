{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kubernetes-helm }:

buildGoModule rec {
  pname = "kubernetes-helm";
<<<<<<< HEAD
  version = "3.12.2";
=======
  version = "3.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-nUkUb41UX9kCIjBrz3AMnaHZSgNoEc+lS6J8Edy6lVA=";
  };
  vendorHash = "sha256-4NsGosKFyl3T3bIndYRP0hhJQ5oj6KuSv4kYH9b83WE=";
=======
    sha256 = "sha256-BIjbSHs0sOLYB+26EHy9f3YJtUYnzgdADIXB4n45Rv0=";
  };
  vendorHash = "sha256-uz3ZqCcT+rmhNCO+y3PuCXWjTxUx8u3XDgcJxt7A37g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w"
    "-s"
    "-X helm.sh/helm/v3/internal/version.version=v${version}"
    "-X helm.sh/helm/v3/internal/version.gitCommit=${src.rev}"
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
