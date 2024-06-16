{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubespy";
  version = "0.6.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "pulumi";
    repo = "kubespy";
    sha256 = "sha256-l/vOIFvCQHq+gOr38SpVZ8ShZdI1bP4G5PY4hKhkCU0=";
  };

  vendorHash = "sha256-4q+eFMrcZsEdk1W7aorIrfS3oVAuD4V0KQ7oJ/5d8nk=";

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
    mainProgram = "kubespy";
    homepage = "https://github.com/pulumi/kubespy";
    license = licenses.asl20;
    maintainers = with maintainers; [ blaggacao ];
  };
}
