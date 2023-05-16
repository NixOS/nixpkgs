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
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "k3sup";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-GppNYNqX/YqRtCYQIe3t2x6eNJCZc/yi6F2xHvA3YXE=";
=======
    sha256 = "sha256-lnr2zMp6gpOM1DtUFIniDd38zR1qnXCmcftlt7dL6P4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

<<<<<<< HEAD
  vendorHash = null;
=======
  vendorHash = "sha256-97m8xz46lvTtZoxO2+pjWmZyZnB2atPuVzYgS9DV+gI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ welteki qjoly ];
=======
    maintainers = with maintainers; [ welteki ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
