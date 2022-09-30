{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, installShellFiles
, bash
, openssh
}:

buildGoModule rec {
  pname = "k3sup";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "k3sup";
    rev = version;
    sha256 = "sha256-2S/VnxVb056aPxFd5LxtUdaNlosHLlu7Tl/RQbY/zpA=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  vendorSha256 = "sha256-97m8xz46lvTtZoxO2+pjWmZyZnB2atPuVzYgS9DV+gI=";

  postConfigure = ''
    substituteInPlace vendor/github.com/alexellis/go-execute/pkg/v1/exec.go \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/alexellis/k3sup/cmd.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/k3sup/cmd.Version=${version}"
  ];

  postInstall = ''
    wrapProgram "$out/bin/k3sup" \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}

    installShellCompletion --cmd k3sup \
      --bash <($out/bin/k3sup completion bash) \
      --zsh <($out/bin/k3sup completion zsh) \
      --fish <($out/bin/k3sup completion fish)
  '';

  meta = with lib; {
    homepage = "https://github.com/alexellis/k3sup";
    description = "Bootstrap Kubernetes with k3s over SSH";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki ];
  };
}
