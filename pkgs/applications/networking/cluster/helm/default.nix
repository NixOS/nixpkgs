{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "0l5rmmrb6b57w1szwp6g7ad3xv0pgvc394mzjr4bi3bzcjsn7wny";
  };
  modSha256 = "0xjzzwmq3i77anb7w2qfnz7vc0gxq02lylj0xs6dzwl543winshm";

  goPackagePath = "k8s.io/helm";
  subPackages = [ "cmd/helm" ];
  buildFlagsArray = [ "-ldflags=-w -s -X helm.sh/helm/v3/internal/version.gitCommit=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    installShellCompletion helm.{bash,zsh}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert ];
  };
}
