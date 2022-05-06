{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubernetes-helm";
  version = "3.8.2";
  gitCommit = "6e3701edea09e5d55a8ca2aae03a68917630e91b";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-lFAzp7ZxyMZAEO1cNFkEPLgTLEGa6azv36xiTIz4FZY=";
  };
  vendorSha256 = "sha256-FLEydmR+UEZ80VYLxBU1ZdwpdLgTjUpqiMItnt9UuLY=";

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w"
    "-s"
    "-X helm.sh/helm/v3/internal/version.version=v${version}"
    "-X helm.sh/helm/v3/internal/version.gitCommit=${gitCommit}"
  ];

  preCheck = ''
    # skipping version tests because they require dot git directory
    substituteInPlace cmd/helm/version_test.go \
      --replace "TestVersion" "SkipVersion"
  '' + lib.optionalString stdenv.isLinux ''
    # skipping plugin tests on linux
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
    installShellCompletion helm.{bash,zsh}
  '';

  meta = with lib; {
    homepage = "https://github.com/kubernetes/helm";
    description = "A package manager for kubernetes";
    mainProgram = "helm";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert Frostman Chili-Man techknowlogick ];
  };
}
