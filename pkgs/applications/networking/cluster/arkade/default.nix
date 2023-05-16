{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "arkade";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "arkade";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-XjJt2bLGBl6T3nrTdwr8lNKW0cBZH+gYFAy6lkNtwgw=";
=======
    sha256 = "sha256-HbwajFTCjiNtAMawI7uBZhIBGyVHUQQjsOrtuxuYmeM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

<<<<<<< HEAD
  vendorHash = null;
=======
  vendorHash = "sha256-/NJ5Y0uN9gAeYvuPWFSFuL83vOS9S8WJeCSZUkOLFMU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Exclude pkg/get: tests downloading of binaries which fail when sandbox=true
  subPackages = [
    "."
    "cmd"
    "pkg/apps"
    "pkg/archive"
    "pkg/config"
    "pkg/env"
    "pkg/helm"
    "pkg/k8s"
    "pkg/types"
  ];

  ldflags = [
    "-s" "-w"
<<<<<<< HEAD
    "-X github.com/alexellis/arkade/pkg.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/arkade/pkg.Version=${version}"
=======
    "-X github.com/alexellis/arkade/cmd.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/arkade/cmd.Version=${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    installShellCompletion --cmd arkade \
      --bash <($out/bin/arkade completion bash) \
      --zsh <($out/bin/arkade completion zsh) \
      --fish <($out/bin/arkade completion fish)
  '';

  meta = with lib; {
    homepage = "https://github.com/alexellis/arkade";
    description = "Open Source Kubernetes Marketplace";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ welteki techknowlogick qjoly ];
=======
    maintainers = with maintainers; [ welteki techknowlogick ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
