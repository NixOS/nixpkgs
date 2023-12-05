{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubespy";
  version = "0.6.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "pulumi";
    repo = "kubespy";
    sha256 = "sha256-eSQl8K+a9YcKXE80bl25+alHoBG8T+LCYOd4Bd9QSdY=";
  };

  vendorHash = "sha256-brs4QIo4QoLHU95llBHN51zYcgQgN7kbMJDMy2OYOsk=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [ "-X" "github.com/pulumi/kubespy/version.Version=${version}" ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kubespy completion $shell > kubespy.$shell
      installShellCompletion kubespy.$shell
    done
  '';

  meta = with lib; {
    description = "A tool to observe Kubernetes resources in real time";
    homepage = "https://github.com/pulumi/kubespy";
    license = licenses.asl20;
    maintainers = with maintainers; [ blaggacao ];
  };
}
